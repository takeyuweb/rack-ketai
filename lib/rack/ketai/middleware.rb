# -*- coding: utf-8 -*-
class Rack::Ketai::Middleware
  
  def initialize(app, options)
    @app = app
    @options = options.dup.clone
  end
  
  def call(env)
    apply(env, Rack::Ketai::Carrier.load(env))
  end

  private
  # 処理適用
  # 携帯端末からのアクセスの場合のみ、
  # env['rack.ketai'] に該当キャリア情報インスタンスをセット
  def apply(env, carrier)
    env = env.clone
    if carrier.mobile?
      env['rack.ketai'] = carrier
    else
      # 互換性維持のため..
      obj = nil
      def obj.mobile?
        false
      end
      env['rack.ketai'] = obj      
    end

    carrier.filtering(env, @options) do |processed_env|
      @app.call(processed_env)
    end
  end

end
