# -*- coding: utf-8 -*-
require 'rack/ketai/carrier/iphone'
describe "Rack::Ketai::Carrier::IPhone" do

  describe "#supports_cookie? を使うとき" do
    # iPhone はCookie対応
    it "#supports_cookie? は true を返す" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; ja-jp) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7')
      mobile = Rack::Ketai::Carrier::IPhone.new(env)
      mobile.should be_respond_to(:supports_cookie?)
      mobile.should be_supports_cookie
    end
  end

end
