# -*- coding: utf-8 -*-
require 'tempfile'
require 'singleton'
require 'nkf'
require 'rack/request'

module Rack::Ketai::Carrier
  class Abstract

    class << self
      def filters
        []
      end
    end

    def initialize(env)
      @env = env
    end
    
    USER_AGENT_REGEXP = nil

    def filtering(env, options = { }, &block)
      env = filters(options).inject(env) { |env, filter| filter.inbound(env) }
      ret = block.call(env)
      ret[2] = ret[2].body if ret[2].is_a?(Rack::Response)
      filters(options).reverse.inject(ret) { |r, filter| filter.outbound(*r) }
    end

    def filters(options = { })
      self.class.filters.collect do |klass|
        klass.new(options)
      end
    end
    
    # 携帯端末か
    def mobile?
      false
    end

  end
end

class Rack::Ketai::Carrier::Abstract
  class Filter

    def initialize(options = { })
      @options = options.clone
    end
    
    def inbound(env)
      env
    end
    
    def outbound(status, headers, body)
      [status, headers, body]
    end

    private
    def full_apply(*argv, &proc)
      argv.each do |obj|
        deep_apply(obj, &proc)
      end
    end
    
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
      
      # 最低でも1回呼んでないと query_string, form_hash等が未設定
      request.params

      # 同一オブジェクトが両方に入ってたりして二重にかかることがあるので
      converted_objects = []
      converter = lambda { |value|
        unless converted_objects.include?(value)
          value = NKF.nkf('-m0 -x -Sw', value)
          converted_objects << value
        end
        value
      }

      full_apply(request.env["rack.request.query_hash"],
                 request.env["rack.request.form_hash"],
                 &converter)

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
      
      case headers['Content-Type']
      when /charset=(\w+)/i
        headers['Content-Type'].sub!(/charset=\w+/, 'charset=shift_jis')
      else
        headers['Content-Type'] << "; charset=shift_jis"
      end

      content = (body.is_a?(Array) ? body[0] : body).to_s
      headers['Content-Length'] = (content.respond_to?(:bytesize) ? content.bytesize : content.size).to_s if headers.member?('Content-Length')
      
      [status, headers, body]
    end
    
  end

end

require 'rack/ketai/carrier/emoji/emojidata'

