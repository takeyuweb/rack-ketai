class Rack::Ketai::Middleware
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    carrier = Rack::Ketai::Carrier.load(env)
    return @app.call(env) unless carrier
    
    apply(env, carrier)
  end

  private
  def apply(env, carrier)
    env = env.clone
    env['rack.ketai'] = carrier
    env = carrier.filters.inject(env) { |env, filter| filter.inbound(env) }
    ret = @app.call(env)
    ret[2] = ret[2].body if ret[2].is_a?(Rack::Response)
    carrier.filters.reverse.inject(ret) { |r, filter| filter.outbound(*r) }
  end

end
