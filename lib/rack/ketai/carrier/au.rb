# -*- coding: utf-8 -*-
require 'scanf'

module Rack
  module Ketai
    module Carrier
      class Au < Abstract
        autoload :CIDRS, 'rack/ketai/carrier/cidrs/au'
        autoload :SPECS, 'rack/ketai/carrier/specs/au'
        
        USER_AGENT_REGEXP = /^(?:KDDI|UP.Browser\/.+?)-(.+?) /
  
        class Filter < ::Rack::Ketai::Carrier::Abstract::SjisFilter

          private
          def to_internal(env)
            # au SJISバイナリ -> 絵文字ID表記
            request = Rack::Request.new(env)
            
            request.params  # 最低でも1回呼んでないと query_stringが未設定
            
            converter = lambda do |value|
              value.force_encoding('Shift_JIS') if value.respond_to?(:force_encoding)
              value.gsub(sjis_regexp) do |match|
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
            
            [status, headers, body]
          end
          
          # 絵文字コード -> 絵文字ID 対応表から、絵文字コード検出用の正規表現をつくる
          # 複数の絵文字の組み合わせのものを前におくことで
          # そっちを優先的にマッチさせる
          def sjis_regexp
            @sjis_regexp if @sjis_regexp
            @sjis_regexp = if RUBY_VERSION >= '1.9.1'
                             codes = EMOJI_TO_EMOJIID.keys.sort_by{ |codes| - codes.size }.collect{ |sjis| Regexp.escape(sjis)}
                             Regexp.new(codes.join('|'), nil)
                           else
                             codes = EMOJI_TO_EMOJIID.keys.sort_by{ |codes| - codes.size }.collect{ |sjis| Regexp.escape(sjis, 's') }
                             Regexp.new(codes.join('|'), nil, 's')
                           end
          end
      
        end
        
        class << self
          def filters
            super | [Rack::Ketai::Carrier::Au::Filter]
          end
        end

        def mobile?
          true
        end

        def subscriberid
          ezno
        end

        def ezno
          @ezno ||= @env['HTTP_X_UP_SUBNO'].to_s =~ /^(\w{14}_\w{2}\.ezweb\.ne\.jp)$/ && $1
        end

        def name
          # UAの最初の - の後ろが略称
          @name ||= @env['HTTP_USER_AGENT'] =~ /^[^\-]+\-(\w+)/ && $1
        end

        def display
          return @display if @display
          width = height = colors = nil
          if @env['HTTP_X_UP_DEVCAP_SCREENPIXELS'].to_s =~ /(\d+),(\d+)/
            width = $1.to_i
            height = $2.to_i
          end
          width ||= spec[5]
          height ||= spec[6]
          
          color_depth = (@env['HTTP_X_UP_DEVCAP_SCREENDEPTH'].to_s =~ /^(\d+)/ && $1).to_i
          colors = color_depth > 0 ? 2 ** color_depth : spec[7]

          @display = Rack::Ketai::Display.new(:colors => colors,
                                              :width => width,
                                              :height => height)
        end

        private
        def spec
          @spec ||= SPECS[name] || []
        end

      end
    end
  end
end

# 変換テーブル読み込み
require 'rack/ketai/carrier/emoji/ausjisstrtoemojiid'


