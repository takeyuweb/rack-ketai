# -*- coding: utf-8 -*-
module Rack::Ketai::Carrier
  class IPhone < General

    USER_AGENT_REGEXP = /iPhone/
    
    def mobile?
      true
    end

    def supports_cookie?
      true
    end
    
  end
end
