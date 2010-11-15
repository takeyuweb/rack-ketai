# -*- coding: utf-8 -*-

require 'scanf'
require 'rack/ketai/carrier/mobile'

module Rack::Ketai::Carrier
  class Docomo < Mobile
    autoload :CIDRS, 'rack/ketai/carrier/cidrs/docomo'
    autoload :SPECS, 'rack/ketai/carrier/specs/docomo'
    
    USER_AGENT_REGEXP = /^DoCoMo/

    class Filter < ::Rack::Ketai::SjisFilter

      # 絵文字コード -> 絵文字ID 対応表から、絵文字コード検出用の正規表現をつくる
      # 複数の絵文字の組み合わせのものを前におくことで
      # そっちを優先的にマッチさせる
      def Filter.sjis_regexp
        @sjis_regexp ||=
          if RUBY_VERSION >= '1.9.1'
            codes = EMOJI_TO_EMOJIID.keys.sort_by{ |codes| - codes.size }.collect{ |sjis| Regexp.escape(sjis)}
            Regexp.new(codes.join('|'), nil)
          else
            codes = EMOJI_TO_EMOJIID.keys.sort_by{ |codes| - codes.size }.collect{ |sjis| Regexp.escape(sjis, 's') }
            Regexp.new(codes.join('|'), nil, 's')
          end
      end
    
      private
      def to_internal(env)
        # ドコモSJISバイナリ -> 絵文字ID表記
        request = Rack::Request.new(env)
        
        request.params  # 最低でも1回呼んでないと query_stringが未設定
        
        converter = lambda do |value|
          value.force_encoding('Shift_JIS') if value.respond_to?(:force_encoding)
          value.gsub(Filter.sjis_regexp) do |match|
            format("[e:%03X]", EMOJI_TO_EMOJIID[match])
          end
        end
        deep_apply(request.env["rack.request.query_hash"], &converter)
        deep_apply(request.env["rack.request.form_hash"], &converter)

        # 文字コード変換
        super(request.env)
      end
      
      def to_external(status, headers, body)
        status, headers, body = super
        
        return [status, headers, body] unless body[0]
        
        body = body.collect do |str|
          str.gsub(/\[e:([0-9A-F]{3})\]/) do |match|
            emojiid = $1.scanf('%X').first
            sjis = EMOJIID_TO_EMOJI[emojiid]
            if sjis
              # 絵文字があるので差替え
              sjis
            else
              # 絵文字がないので代替文字列
              emoji_data = EMOJI_DATA[emojiid]
              NKF.nkf('-Ws', (emoji_data[:fallback] || emoji_data[:name] || '〓'))
            end
          end
        end
        
        content = (body.is_a?(Array) ? body[0] : body).to_s
        headers['Content-Length'] = (content.respond_to?(:bytesize) ? content.bytesize : content.size).to_s if headers.member?('Content-Length')
        
        headers['Content-Type'].sub! Regexp.new(Regexp.quote('text/html')), 'application/xhtml+xml' if headers['Content-Type']

        [status, headers, body]
      end
    end
      
    class << self
      def filters
        super | [Rack::Ketai::Carrier::Docomo::Filter]
      end
    end
    
    # 端末個体識別子があれば返す。
    def deviceid
      case @env['HTTP_USER_AGENT']
      when /ser([0-9a-zA-Z]{11})$/ # mova
        return $1
      when /ser([0-9a-zA-Z]{15});/ # FOMA
        return $1
      else
        return nil
      end
    end

    # iモードIDかFOMAカード個体識別子を返す
    # iモードIDの方が優先度が高い
    def subscriberid
      guid || icc
    end

    # FOMAカード個体識別子
    def icc
      @icc ||= @env['HTTP_USER_AGENT'] =~ /icc([0-9a-zA-Z]{20})\)/ && $1
    end

    # iモードID
    def guid
      @guid ||= @env['HTTP_X_DCMGUID'] =~ /([0-9A-Za-z]{7})/ && $1
    end

    # 機種名
    def name
      @name ||= @env['HTTP_USER_AGENT'].split(/[\/\s\(\)]+/)[2]
    end

    # 位置情報
    # http://www.nttdocomo.co.jp/service/imode/make/content/gps/
    # 「GPS機能対応iモード端末にて測位した場合、世界測地系となります」とのこと
    def position
      lat = request.params['lat']
      lon = request.params['lon']
      return nil unless lat && lon
      
      @position ||= Rack::Ketai::Position.new(:lat => lat, :lng => lon)
    end

    # ディスプレイ情報
    def display
      @display ||= Rack::Ketai::Display.new(:colors => spec[7],
                                            :width => spec[5],
                                            :height => spec[6])
    end

    # キャッシュサイズ（Byte）
    # 不明なら最低の5KBを返す
    def cache_size
      return @cache_size if @cache_size
      @cache_size ||= if @env['HTTP_USER_AGENT'] =~ /DoCoMo\/\d\.\d\/[^\/]+\/c(\d+)/ ||
                          @env['HTTP_USER_AGENT'] =~ /DoCoMo\/\d\.\d[^\(]+\(c(\d+)/
                        $1.to_i * 1000
                      else
                        5000
                      end
    end
    
    # Cookie対応
    # iモードブラウザ2.0 なら Cookie対応
    # ただしiモードブラウザ2.0かどうかはキャッシュサイズ(500K)から判断するしかない
    # キャッシュサイズが取得できなかったらやむを得ずデータ参照（信頼性低い）
    def supports_cookie?
      cache_size >= 500000 || (spec[8].to_i >= 500 || spec[20].to_i > 0)
    end

    private
    def spec
      @spec = SPECS[name] || []
    end

  end
end

# 変換テーブル読み込み
require 'rack/ketai/carrier/emoji/docomosjisstrtoemojiid'

