# -*- coding: utf-8 -*-

# 一般的な環境（PCその他）
# 現在はフィルタ用のみに利用
# アプリ側では利用しないこと（できません）

module Rack::Ketai::Carrier
  class General < Abstract

    class EmoticonFilter < Rack::Ketai::Filter
      EMOJIID_REGEXP = Regexp.new('\[e:([0-9A-F]{3})\]').freeze
      INSIDE_INPUT_TAG = Regexp.new('(<input\s.*?\svalue=")(.*?)(".*?>)').freeze
      INSIDE_TEXTAREA_TAG = Regexp.new('(<textarea\s.*?>)(.*?)(</textarea>)', Regexp::MULTILINE).freeze

      private
      def to_internal(env)
        super(env)
      end

      # emoji4unicodeのIDからimgタグに変換
      # ただし、content-type がhtmlでないときおよび、
      # input内、textarea内では変換しない
      def to_external(status, headers, body)
        return [status, headers, body] unless body && !@options[:emoticons_path].to_s.empty? && (headers['Content-Type'].to_s.empty? || headers['Content-Type'].to_s =~ /html/)

        emoticons_path = @options[:emoticons_path]
        
        output = ''
        body.collect do |str|
          # input内・textarea内以外のものだけを置換する良い方法がわからないので、
          # とりあえず、input内、textarea内のものを別なのにしとく
          str = str.gsub(INSIDE_INPUT_TAG) do
            prefix, value, suffix = $1, $2, $3
            prefix << value.gsub(EMOJIID_REGEXP){ |m| "[E:#{$1}]"} << suffix
          end

          str = str.gsub(INSIDE_TEXTAREA_TAG) do
            prefix, value, suffix = $1, $2, $3
            prefix << value.gsub(EMOJIID_REGEXP){ "[E:#{$1}]" } << suffix
          end

          str = str.gsub(EMOJIID_REGEXP) do |match|
            emojiid = $1.scanf('%X').first
            filenames = EMOJIID_TO_TYPECAST_EMOTICONS[emojiid]
            if filenames
              # 絵文字アイコンがあるのでimgタグに
              filenames.collect{|filename| "<img src=\"#{File.join('/', emoticons_path, filename)}.gif\" />" }.join("")
            else
              # 絵文字がないので代替文字列
              emoji_data = EMOJI_DATA[emojiid]
              emoji_data[:fallback] || emoji_data[:name] || '〓'
            end
          end

          # とりあえず変えておいたものを戻す
          output << str.gsub(/\[E:([0-9A-F]{3})\]/){ "[e:#{$1}]" }
        end
        
        headers['Content-Length'] = (output.respond_to?(:bytesize) ? output.bytesize : output.size).to_s if headers.member?('Content-Length')
        
        [status, headers, [output]]
      end
      
    end

    class << self
      def filters
        super | [Rack::Ketai::Carrier::General::EmoticonFilter]
      end
    end

  end
end

# 変換テーブル読み込み
require 'rack/ketai/carrier/emoji/emojiidtotypecast'

