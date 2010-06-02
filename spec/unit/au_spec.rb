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

      it "#name で機種名を取得できること" do
        @mobile.name.should == 'SA31'
      end
      
    end

    describe "ディスプレイ情報を取得できること" do
      
      describe "既知の端末のとき" do 

        it "環境変数を優先すること" do
          @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                           'HTTP_USER_AGENT' => 'KDDI-TS31 UP.Browser/6.2.0.8 (GUI) MMP/2.0',
                                           'HTTP_X_UP_DEVCAP_SCREENPIXELS' => '1024,768',
                                           'HTTP_X_UP_DEVCAP_SCREENDEPTH' => '8')
          @mobile = Rack::Ketai::Carrier::Au.new(@env)
          display = @mobile.display
          display.should_not be_nil
          display.colors.should == 256
          display.width.should == 1024
          display.height.should == 768
          
          @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                           'HTTP_USER_AGENT' => 'KDDI-TS31 UP.Browser/6.2.0.8 (GUI) MMP/2.0')
          @mobile = Rack::Ketai::Carrier::Au.new(@env)
          display = @mobile.display
          display.should_not be_nil
          display.colors.should == 65536
          display.width.should == 229
          display.height.should == 270
        end

      end

      describe "未知の端末のとき" do 

        it "環境変数から設定すること" do
          @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                           'HTTP_USER_AGENT' => 'KDDI-XX01 UP.Browser/6.2.0.8 (GUI) MMP/2.0',
                                           'HTTP_X_UP_DEVCAP_SCREENPIXELS' => '1024,768',
                                           'HTTP_X_UP_DEVCAP_SCREENDEPTH' => '8')
          @mobile = Rack::Ketai::Carrier::Au.new(@env)
          display = @mobile.display
          display.should_not be_nil
          display.colors.should == 256
          display.width.should == 1024
          display.height.should == 768
        end

        it "環境変数が無かったら慌てず騒がず nil を返す" do
          @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                           'HTTP_USER_AGENT' => 'KDDI-XX01 UP.Browser/6.2.0.8 (GUI) MMP/2.0')
          @mobile = Rack::Ketai::Carrier::Au.new(@env)
          display = @mobile.display
          display.should_not be_nil
          display.colors.should be_nil
          display.width.should be_nil
          display.height.should be_nil
        end

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
