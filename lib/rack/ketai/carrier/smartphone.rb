# -*- coding: utf-8 -*-

require 'rack/ketai/carrier/mobile'

module Rack::Ketai::Carrier
  class Smartphone < Mobile
    CIDRS = []

    def smartphone?
      true
    end

  end
end


