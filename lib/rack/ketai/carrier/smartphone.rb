# -*- coding: utf-8 -*-

require 'rack/ketai/carrier/general'

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


