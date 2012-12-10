# -*- coding: utf-8 -*-

require 'rack/ketai/carrier/abstract'

module Rack::Ketai::Carrier
  class Mobile < Abstract
    
    def mobile?
      true
    end

    def featurephone?
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
      converter = lambda {  |value|
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
      output = ''

      (body.respond_to?(:each) ? body : [body]).each do |str|
        output << NKF.nkf('-m0 -x -Ws', str)
      end

      if headers['Content-Type']
        case headers['Content-Type']
        when /charset=[\w\-]+/i
          headers['Content-Type'] = headers['Content-Type'].sub(/charset=[\w\-]+/, 'charset=shift_jis')
        else
          headers['Content-Type'] = headers['Content-Type'] + "; charset=shift_jis"
        end
      end

      headers['Content-Length'] = (output.respond_to?(:bytesize) ? output.bytesize : output.size).to_s if headers.member?('Content-Length')
    
      [status, headers, [output]]
    end
    
  end

end
