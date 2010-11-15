module Rack::Ketai
  class Filter

    def initialize(options = { })
      @options = options.clone
    end
    
    def inbound(env)
      apply_incoming?(env) ? to_internal(env) : env
    end
    
    def outbound(status, headers, body)
      body = [body].flatten
      apply_outgoing?(status, headers, body) ? to_external(status, headers, body) : [status, headers, body]
    end

    private
    def to_internal(env)
      env
    end
    
    def to_external(status, headers, body)
      if headers['Content-Type']
        case headers['Content-Type']
        when /charset=[\w\-]+/i
          headers['Content-Type'].sub!(/charset=[\w\-]+/, 'charset=utf-8')
        else
          headers['Content-Type'] << "; charset=utf-8"
        end
      end
      [status, headers, body]
    end
    
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

    def apply_incoming?(env); true; end
    def apply_outgoing?(status, headers, body)
      headers['Content-Type'] !~ /^(.+?)(?:;|$)/
      [nil, "text/html", "application/xhtml+xml"].include?($1)
    end

  end

end

require 'rack/ketai/carrier/emoji/emojidata'
