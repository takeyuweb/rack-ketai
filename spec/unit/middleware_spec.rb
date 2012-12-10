# -*- coding: utf-8 -*-
require 'spec_helper'

describe Rack::Ketai::Middleware, "#call を実行するとき" do

  it "適切な env['rack.ketai'] を設定できること" do
    {
      'DoCoMo/1.0/N505i' => Rack::Ketai::Carrier::Docomo, # Mova
      'DoCoMo/2.0 P903i' => Rack::Ketai::Carrier::Docomo, # FOMA
      'KDDI-CA39 UP.Browser/6.2.0.13.1.5 (GUI) MMP/2.0' => Rack::Ketai::Carrier::Au, # WAP2.0 MMP2.0
      'KDDI-TS21 UP.Browser/6.0.2.273 (GUI) MMP/1.1' => Rack::Ketai::Carrier::Au, # WAP2.0 MMP1.1
      'SoftBank/1.0/930SH/SHJ001[/Serial] Browser/NetFront/3.4 Profile/MIDP-2.0 Configuration/CLDC-1.1' => Rack::Ketai::Carrier::Softbank, # SoftBank 3GC
      'Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_0_1 like Mac OS X; ja-jp) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5B108 Safari/525.20' => Rack::Ketai::Carrier::IPhone,
      'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; Q312461; .NET CLR 1.0.3705; .NET CLR 1.1.4322; .NET CLR 2.0.50727)' => nil, # IE8
      'Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1' => nil,
      'Opera/9.21 (Windows NT 5.1; U; ja)' => nil,
      'Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP) AppleWebKit/525.19 (KHTML, like Gecko) Version/3.1.2 Safari/525.21' => nil,
      'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.29 Safari/525.13' => nil,
    }.each do |ua, carrier|
      mock_env = Rack::MockRequest.env_for('http://hoge.com/dummy','HTTP_USER_AGENT' => ua)

      mock_app = mock('App')
      mock_app.should_receive(:call) do |env|
        if carrier
          env['rack.ketai'].should_not be_nil
          env['rack.ketai'].mobile?.should be_true
        else
          env['rack.ketai'].should be_nil
          env['rack.ketai'].mobile?.should be_false
        end
        [200, { "Content-Type" => "text/plain"}, ["OK"]]
      end
      
      middleware = Rack::Ketai::Middleware.new(mock_app, { })
      middleware.call(mock_env)
    end
  end

end
