# -*- coding: utf-8 -*-
require 'rack/ketai/carrier/au'
describe "Rack::Ketai::Carrier::Au" do

  before(:each) do
    
  end
  
  describe "WAP2.0ブラウザ搭載端末で" do

    # http://ke-tai.org/blog/2008/09/08/phoneid/
    # http://www.au.kddi.com/ezfactory/tec/spec/4_4.html

    describe "EZ番号（サブスクライバID）を取得できたとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0',
                                         'HTTP_X_UP_SUBNO' => '01234567890123_xx.ezweb.ne.jp')
        @mobile = Rack::Ketai::Carrier::Au.new(@env)
      end
      
      it "#subscriberid でEZ番号を取得できること" do
        @mobile.subscriberid.should == '01234567890123_xx.ezweb.ne.jp'
      end
      
      it "#deviceid は nil なこと" do
        @mobile.deviceid.should be_nil
      end

      it "#ident でEZ番号を取得できること" do
        @mobile.ident.should == @mobile.subscriberid
        @mobile.ident.should == '01234567890123_xx.ezweb.ne.jp'
      end
    end

    describe "EZ番号が取得できないとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
        @mobile = Rack::Ketai::Carrier::Au.new(@env)
      end
      
      it "#subscriberid は nil を返すこと" do
        @mobile.subscriberid.should be_nil
      end
      
      it "#deviceid は nil を返すこと" do
        @mobile.deviceid.should be_nil
      end

      it "#ident は nil を返すこと" do
        @mobile.ident.should be_nil
      end
    end

  end

end
