# -*- coding: utf-8 -*-

require 'rack/ketai/carrier/smartphone'

module Rack::Ketai::Carrier
  class IPhone < Smartphone

    USER_AGENT_REGEXP = /iPhone|iPod|iPad/
    
    def supports_cookie?
      true
    end

    def smartphone?
      super && !tablet?
    end

    def tablet?
      @env['HTTP_USER_AGENT'].to_s =~ /iPad/
    end
    
  end
end
