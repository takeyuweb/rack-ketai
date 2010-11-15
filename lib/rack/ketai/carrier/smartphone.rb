# -*- coding: utf-8 -*-

require 'rack/ketai/carrier/mobile'

module Rack::Ketai::Carrier
  class Smartphone < General
    CIDRS = []

    def mobile?
      true
    end

    def smartphone?
      true
    end

  end
end


