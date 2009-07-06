# -*- coding: utf-8 -*-
module Rack::Ketai::Carrier
  class Softbank < Abstract

    # Semulator はウェブコンテンツビューアのUA
    USER_AGENT_REGEXP = /^(?:SoftBank|Semulator)/
    
  end
end
