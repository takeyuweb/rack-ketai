module Rack::Ketai::Carrier
  class Au < Abstract

    USER_AGENT_REGEXP = /^(?:KDDI|UP.Browser\/.+?)-(.+?) /

    self.filters = [Rack::Ketai::Filter::Sjis.new]
  end
end
