require 'nkf'

module Rack::Ketai::Carrier
  class Docomo < Abstract

    USER_AGENT_REGEXP = /^DoCoMo/

    self.filters = [Rack::Ketai::Filter::Sjis.new]

  end
end
