# -*- coding: utf-8 -*-

require 'rack/ketai/carrier/smartphone'

module Rack::Ketai::Carrier
  class Android < Smartphone

    USER_AGENT_REGEXP = /Android/
    
    def supports_cookie?
      true
    end
    
  end
end
