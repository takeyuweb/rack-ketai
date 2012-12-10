# -*- coding: utf-8 -*-

require 'rack/ketai/carrier/smartphone'

module Rack::Ketai::Carrier
  class Android < Smartphone

    USER_AGENT_REGEXP = /Android/
    
    def supports_cookie?
      true
    end

    def smartphone?
      super && !tablet?
    end

    def tablet?
      @env['HTTP_USER_AGENT'].to_s !~ /Mobile/ ||
        @env['HTTP_USER_AGENT'].to_s =~ /SC-01C/
    end
    
  end
end
