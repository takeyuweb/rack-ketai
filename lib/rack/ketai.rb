module Rack::Ketai

  autoload :Middleware, 'rack/ketai/middleware'
  autoload :Carrier, 'rack/ketai/carrier'
  autoload :Filter, 'rack/ketai/filter'

  def self.new(app)
    Middleware.new(app)
  end
  
end
