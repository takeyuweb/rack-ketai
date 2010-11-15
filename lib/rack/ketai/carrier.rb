module Rack::Ketai::Carrier

  autoload :General, 'rack/ketai/carrier/general'
  autoload :Docomo, 'rack/ketai/carrier/docomo'
  autoload :Au, 'rack/ketai/carrier/au'
  autoload :Softbank, 'rack/ketai/carrier/softbank'
  autoload :IPhone, 'rack/ketai/carrier/iphone'
  autoload :Android, 'rack/ketai/carrier/android'

  def self.load(env)
    constants.each do |const|
      c = self.const_get(const)
      return c.new(env) if c::USER_AGENT_REGEXP && env['HTTP_USER_AGENT'] =~ c::USER_AGENT_REGEXP
    end
    General.new(env)
  end

end
