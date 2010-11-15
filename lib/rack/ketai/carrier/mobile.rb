# -*- coding: utf-8 -*-

require 'rack/ketai/carrier/abstract'

module Rack::Ketai::Carrier
  class Mobile < Abstract
    
    def mobile?
      true
    end

  end
end

module Rack::Ketai
  class SjisFilter < Filter

    private
    def to_internal(env)
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
    
    def to_external(status, headers, body)
      if body.is_a?(Array)
        body = body.collect do |str|
          NKF.nkf('-m0 -x -Ws', str)
        end
      else
        body = NKF.nkf('-m0 -x -Ws', body)
      end

      if headers['Content-Type']
        case headers['Content-Type']
        when /charset=[\w\-]+/i
          headers['Content-Type'].sub!(/charset=[\w\-]+/, 'charset=shift_jis')
        else
          headers['Content-Type'] << "; charset=shift_jis"
        end
      end

      content = (body.is_a?(Array) ? body[0] : body).to_s
      headers['Content-Length'] = (content.respond_to?(:bytesize) ? content.bytesize : content.size).to_s if headers.member?('Content-Length')
    
      [status, headers, body]
    end
    
  end

end
