# -*- coding: utf-8 -*-
require 'tempfile'
require 'singleton'
require 'nkf'
require 'rack/request'

module Rack::Ketai::Carrier
  class Abstract

    class << self
      @@filter_table = { }
      def filters=(obj)
        @@filter_table[self] = obj.is_a?(Array) ? obj : [obj]
      end

      def filters
        @@filter_table[self] ||= []
      end
    end

    def initialize(env)
      @env = env.clone
    end
    
    USER_AGENT_REGEXP = nil

    def filters
      self.class.filters
    end

    private
    def inbound_filter
    end

    def outbound_filter
    end

  end
end

class Rack::Ketai::Carrier::Abstract
  class Filter
    include Singleton

    def inbound(env)
      env
    end
    
    def outbound(status, headers, body)
      [status, headers, body]
    end

    private
    # jpmobile より
    def deep_apply(obj, &proc)
      case obj
      when Hash
        obj.each_pair do |key, value|
          obj[key] = deep_apply(value, &proc)
        end
        obj
      when Array
        obj.collect!{ |value| deep_apply(value, &proc)}
      when NilClass, TrueClass, FalseClass, Tempfile, StringIO
        obj
      else
        proc.call(obj)
      end
    end

  end

  
  class SjisFilter < Filter

    def inbound(env)
      request = Rack::Request.new(env)
      
      request.params  # 最低でも1回呼んでないと query_string, form_hash等が未設定
      
      converter = lambda { |value| NKF.nkf('-m0 -x -Sw', value) }
      deep_apply(env["rack.request.query_hash"], &converter)
      deep_apply(env["rack.request.form_hash"], &converter)
      
      request.env
    end
    
    def outbound(status, headers, body)
      if body.is_a?(Array)
        body = body.collect do |str|
          NKF.nkf('-m0 -x -Ws', str)
        end
      else
        body = NKF.nkf('-m0 -x -Ws', body)
      end
      
      content = (body.is_a?(Array) ? body[0] : body).to_s
      headers['Content-Length'] = (content.respond_to?(:bytesize) ? content.bytesize : content.size).to_s if headers.member?('Content-Length')
      
      [status, headers, body]
    end
    
  end

end

require 'rack/ketai/carrier/emoji/emojidata'

