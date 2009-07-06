require 'nkf'
require 'rack/request'
module Rack::Ketai::Filter
  class Sjis < Abstract

    def inbound(env)
      request = Rack::Request.new(env)
      deep_apply(request.params) do |value|
        value = NKF.nkf('-m0 -x -Sw', value)
      end
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

      content = body.is_a?(Array) ? body[0] : body
      headers['Content-Length'] = (content.respond_to?(:bytesize) ? content.bytesize : content.size).to_s

      [status, headers, body]
    end

  end
end
