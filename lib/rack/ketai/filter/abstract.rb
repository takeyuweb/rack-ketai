# -*- coding: utf-8 -*-
require 'tempfile'

module Rack::Ketai::Filter
  class Abstract

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
      when Array
        obj.collect!{ |value| deep_apply(value, &proc)}
      when NilClass, TrueClass, FalseClass, Tempfile, StringIO
        return obj
      else
        proc.call(obj)
      end
    end

  end
end
