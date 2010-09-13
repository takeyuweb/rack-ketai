module Rack::Ketai

  autoload :Middleware, 'rack/ketai/middleware'
  autoload :Position, 'rack/ketai/position'
  autoload :Display, 'rack/ketai/display'
  autoload :Carrier, 'rack/ketai/carrier'
  autoload :Filter, 'rack/ketai/filter'

  def self.new(app, options = { })
    Middleware.new(app, options)
  end
  
end
