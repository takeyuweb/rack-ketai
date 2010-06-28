# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
require 'scanf'

module Rack::Ketai::Carrier
  class Softbank < Abstract
    autoload :CIDRS, 'rack/ketai/carrier/cidrs/softbank'
    autoload :SPECS, 'rack/ketai/carrier/specs/softbank'
    
    # Semulator はウェブコンテンツビューアのUA
    USER_AGENT_REGEXP = /^(?:Vodafone|SoftBank|Semulator)/

    class Filter < ::Rack::Ketai::Carrier::Abstract::Filter

      # 絵文字コード -> 絵文字ID 対応表から、絵文字コード検出用の正規表現をつくる
      # 複数の絵文字の組み合わせのものを前におくことで
      # そっちを優先的にマッチさせる
      def Filter.emoji_utf8_regexp
        @emoji_utf8_regexp ||= Regexp.union(*EMOJI_TO_EMOJIID.keys.sort_by{ |codes| - codes.size }.collect{ |utf8str| Regexp.new(Regexp.escape(utf8str), nil)})
      end

      private
      def to_internal(env)
        # softbank UTF-8バイナリ(Unicode) -> 絵文字ID表記
        request = Rack::Request.new(env)
        
        request.params  # 最低でも1回呼んでないと query_stringが未設定
        
        converter = lambda do |value|
          value.force_encoding('UTF-8') if value.respond_to?(:force_encoding)
          # まずウェブコードを変換
          value = value.gsub(/\x1B\$([GEFOPQ])([\x21-\x7E]+)\x0F/u) do |match|
            head = $1
            $2.split(//u).collect { |b| WEBCODE_TO_EMOJI[head+b]}.join('')
          end
          # UTF-8バイナリから絵文字IDに
          value.gsub(Filter.emoji_utf8_regexp) do |match|
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
            utf8str = EMOJIID_TO_EMOJI[emojiid]
            if utf8str
              # 絵文字があるので差替え
              utf8str.split(//u).collect { |b| "\x1B$"+WEBCODE_TO_EMOJI.index(b)+"\x0F" }.join("")
            else
              # 絵文字がないので代替文字列
              emoji_data = EMOJI_DATA[emojiid]
              emoji_data[:fallback] || emoji_data[:name] || '〓'
            end
          end
        end
        
        content = (body.is_a?(Array) ? body[0] : body).to_s
        headers['Content-Length'] = (content.respond_to?(:bytesize) ? content.bytesize : content.size).to_s if headers.member?('Content-Length')
        
        [status, headers, body]
      end
    end

    class << self
      def filters
        super | [Rack::Ketai::Carrier::Softbank::Filter]
      end
    end
    
    def mobile?
      true
    end

    def subscriberid
      @env['HTTP_X_JPHONE_UID'].to_s =~ /^([A-z|0-9]+)$/
      $1
    end

    def deviceid
      @env['HTTP_USER_AGENT'].to_s =~ /\/SN(\w+) /
      $1
    end

    def name
      return @name if @name
      @name = @env['HTTP_X_JPHONE_MSNAME']
      @name ||= @env['HTTP_USER_AGENT'].split(/\//)[2] # x-jphone-msname が無いときはUAから
    end

    def display
      return @display if @display
      width = height = colors = nil
      # HTTP_X_JPHONE_DISPLAY 480*854
      # HTTP_X_S_DISPLAY_INFO 480*854/30*23/TB
      if @env['HTTP_X_JPHONE_DISPLAY'].to_s =~ /^(\d+)\*(\d+)/ ||
          @env['HTTP_X_S_DISPLAY_INFO'].to_s =~ /^(\d+)\*(\d+)/
        width = $1.to_i
        height = $2.to_i
      end
      width ||= spec[5]
      height ||= spec[6]
      
      colors = @env['HTTP_X_JPHONE_COLOR'] =~ /^C(\d+)/ && $1.to_i
      colors ||= spec[7]

      @display = Rack::Ketai::Display.new(:colors => colors,
                                          :width => width,
                                          :height => height)
    end

    def supports_cookie?
      true
    end

    def cache_size
      @cache_size ||= ((val = spec[8].to_i) >= 200 ? val : 300) * 1000
    end

    private
    def spec
      @spec = SPECS[name] || []
    end

  end
end

class Rack::Ketai::Carrier::Softbank
  
end

# 変換テーブル読み込み
require 'rack/ketai/carrier/emoji/softbankwebcodetoutf8str'
require 'rack/ketai/carrier/emoji/softbankutf8strtoemojiid'

