module Rack::Ketai::Carrier

  autoload :Abstract, 'rack/ketai/carrier/abstract'
  autoload :Docomo, 'rack/ketai/carrier/docomo'
  autoload :Au, 'rack/ketai/carrier/au'
  autoload :Softbank, 'rack/ketai/carrier/softbank'
  autoload :IPhone, 'rack/ketai/carrier/iphone'
  
  def self.load(env)
    constants.each do |const|
      c = self.const_get(const)
      return c.new(env) if c::USER_AGENT_REGEXP && env['HTTP_USER_AGENT'] =~ c::USER_AGENT_REGEXP
    end
    nil
  end

end
