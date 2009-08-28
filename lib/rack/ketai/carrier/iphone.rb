# -*- coding: utf-8 -*-
module Rack::Ketai::Carrier
  class IPhone < General

    USER_AGENT_REGEXP = /iPhone/
    
    def mobile?
      true
    end

  end
end
