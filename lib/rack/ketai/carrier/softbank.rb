# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
require 'scanf'

module Rack::Ketai::Carrier
  class Softbank < Abstract
    # Semulator はウェブコンテンツビューアのUA
    USER_AGENT_REGEXP = /^(?:SoftBank|Semulator)/

    class Filter < ::Rack::Ketai::Carrier::Abstract::Filter
      
      def inbound(env)
        # softbank UTF-8バイナリ(Unicode) -> 絵文字ID表記
        request = Rack::Request.new(env)
        
        request.params  # 最低でも1回呼んでないと query_stringが未設定
        
        converter = lambda do |value|
          # まずウェブコードを変換
          value = value.gsub(/\x1B\$([GEFOPQ])([\x21-\x7E]+)\x0F/u) do |match|
            head = $1
            $2.split(//u).collect { |b| WEBCODE_TO_EMOJI[head+b]}
          end
          
          # UTF-8バイナリから絵文字IDに
          value.gsub(emoji_utf8_regexp) do |match|
            format("[e:%03X]", EMOJI_TO_EMOJIID[match])
          end
        end
        deep_apply(request.env["rack.request.query_hash"], &converter)
        deep_apply(request.env["rack.request.form_hash"], &converter)
        
        # 文字コード変換
        super(request.env)
      end
      
      def outbound(status, headers, body)
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
      
      private
      # 絵文字コード -> 絵文字ID 対応表から、絵文字コード検出用の正規表現をつくる
      # 複数の絵文字の組み合わせのものを前におくことで
      # そっちを優先的にマッチさせる
      def emoji_utf8_regexp
        @emoji_utf8_regexp if @emoji_utf8_regexp
        @emoji_utf8_regexp = Regexp.union(*EMOJI_TO_EMOJIID.keys.sort_by{ |codes| - codes.size }.collect{ |utf8str| Regexp.new(Regexp.escape(utf8str), nil)})
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

  end
end

class Rack::Ketai::Carrier::Softbank
  
end

# 変換テーブル読み込み
require 'rack/ketai/carrier/emoji/softbankwebcodetoutf8str'
require 'rack/ketai/carrier/emoji/softbankutf8strtoemojiid'

