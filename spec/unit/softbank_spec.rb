# -*- coding: utf-8 -*-
require 'rack/ketai/carrier/softbank'
describe "Rack::Ketai::Carrier::Softbank" do

  before(:each) do
    
  end
  
  # http://creation.mb.softbank.jp/web/web_ua_about.html
  # SoftBank 3G Series => 3GC型
  # C型 P型は省略（もうなくなるし）

  describe "3GCケータイで" do

    # http://ke-tai.org/blog/2008/09/08/phoneid/
    # http://creation.mb.softbank.jp/web/web_ua_about.html

    describe "端末シリアル番号とX-JPHONE-UIDが送信されたとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'SoftBank/1.0/824T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1',
                                         'HTTP_X_JPHONE_UID' => 'c10Sty5bmqjsZeb2')
        @mobile = Rack::Ketai::Carrier::Softbank.new(@env)
      end
      
      it "#subscriberid でx-jphone-uidを取得できること" do
        @mobile.subscriberid.should == 'c10Sty5bmqjsZeb2'
      end
      
      it "#deviceid で端末シリアル番号を取得できること" do
        @mobile.deviceid.should == '000000000000000'
      end

      it "#ident でx-jphone-uidを取得できること" do
        @mobile.ident.should == @mobile.subscriberid
        @mobile.ident.should == 'c10Sty5bmqjsZeb2'
      end
    end

    describe "端末シリアル番号の送出が禁止されているとき（最近のはデフォルトでこう）" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'SoftBank/1.0/824T/TJ001 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1',
                                         'HTTP_X_JPHONE_UID' => 'c10Sty5bmqjsZeb2')
        @mobile = Rack::Ketai::Carrier::Softbank.new(@env)
      end
      
      it "#subscriberid でx-jphone-uidを取得できること" do
        @mobile.subscriberid.should == 'c10Sty5bmqjsZeb2'
      end
      
      it "#deviceid が nil を返すこと" do
        @mobile.deviceid.should be_nil
      end

      it "#ident でx-jphone-uidを取得できること" do
        @mobile.ident.should == @mobile.subscriberid
        @mobile.ident.should == 'c10Sty5bmqjsZeb2'
      end
    end

    describe "X-JPHONE-UIDの送出が禁止されているとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'SoftBank/1.0/824T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1')
        @mobile = Rack::Ketai::Carrier::Softbank.new(@env)
      end
      
      it "#subscriberid が nil を返すこと" do
        @mobile.subscriberid.should be_nil
      end
      
      it "#deviceid で端末シリアル番号を取得できること" do
        @mobile.deviceid.should == '000000000000000'
      end

      it "#ident で端末シリアル番号を取得できること" do
        @mobile.ident.should == @mobile.deviceid
        @mobile.ident.should == '000000000000000'
      end
    end

    describe "端末シリアル番号もX-JPHONE-UIDも送出が禁止されているとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'SoftBank/1.0/824T/TJ001 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1')
        @mobile = Rack::Ketai::Carrier::Softbank.new(@env)
      end
      
      it "#subscriberid が nil を返すこと" do
        @mobile.subscriberid.should be_nil
      end
      
      it "#deviceid が nil を返すこと" do
        @mobile.deviceid.should be_nil
      end

      it "#ident が nil を返すこと" do
        @mobile.ident.should be_nil
      end
    end

  end

end
