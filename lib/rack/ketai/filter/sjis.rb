# -*- coding: utf-8 -*-
require 'nkf'
require 'rack/request'
module Rack::Ketai::Filter
  class Sjis < Abstract

    def inbound(env)
      request = Rack::Request.new(env)

      request.GET  # 最低でも1回呼んでないと query_stringが未設定

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
