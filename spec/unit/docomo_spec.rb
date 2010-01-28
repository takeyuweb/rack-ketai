# -*- coding: utf-8 -*-
require 'rack/ketai/carrier/docomo'
describe "Rack::Ketai::Carrier::Docomo" do

  # UAの意味
  # http://www.nttdocomo.co.jp/service/imode/make/content/browser/html/useragent/

  before(:each) do
    
  end
  
  describe "FOMA端末で" do

    # http://www.nttdocomo.co.jp/service/imode/make/content/browser/html/tag/utn.html
    # FOMA端末製造番号のみ、もしくはFOMAカード製造番号のみの送信はできません。 

    describe "iモードIDを取得できたとき" do
      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy?guid=ON',
                                         'HTTP_USER_AGENT' => 'DoCoMo/2.0 P903i(c10;serXXXXXXXXXXXXXXX; iccxxxxxxxxxxxxxxxxxxxx)',
                                         'HTTP_X_DCMGUID' => '0123abC')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
      end
      
      it "#subscriberid でiモードIDを取得できること" do
        @mobile.subscriberid.should == '0123abC'
      end
            
      it "#deviceid でFOMA端末個体識別子を取得できること" do
        @mobile.deviceid.should == "XXXXXXXXXXXXXXX"
      end
      
      it "#ident でiモードIDを取得できること" do
        @mobile.ident.should == @mobile.subscriberid
        @mobile.ident.should == '0123abC'
      end
      
    end
    
    describe "iモードIDが取得できず、FOMAカード個体識別子、FOMA端末個体識別子双方を取得できたとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'DoCoMo/2.0 P903i(c10;serXXXXXXXXXXXXXXX; iccxxxxxxxxxxxxxxxxxxxx)')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
      end
      
      it "#subscriberid でFOMAカード個体識別子を取得できること" do
        @mobile.subscriberid.should == "xxxxxxxxxxxxxxxxxxxx"
      end
      
      it "#deviceid でFOMA端末個体識別子を取得できること" do
        @mobile.deviceid.should == "XXXXXXXXXXXXXXX"
      end

      it "#ident でFOMAカード個体識別子を取得できること" do
        @mobile.ident.should == @mobile.subscriberid
        @mobile.ident.should == "xxxxxxxxxxxxxxxxxxxx"
      end
    end

    describe "iモードID、FOMAカード個体識別子およびFOMA端末個体識別子が取得できないとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'DoCoMo/2.0 SO903i')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
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

    describe "iモードIDが取得でき、FOMAカード個体識別子およびFOMA端末個体識別子が取得できないとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'DoCoMo/2.0 SO903i',
                                         'HTTP_X_DCMGUID' => '0123abC')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
      end
      
      it "#subscriberid はiモードIDを返すこと" do
        @mobile.subscriberid.should == '0123abC'
      end
      
      it "#deviceid は nil を返すこと" do
        @mobile.deviceid.should be_nil
      end

      it "#ident はiモードIDを返すこと" do
        @mobile.ident.should == '0123abC'
      end
    end

  end

  describe "mova端末で" do

    # http://www.nttdocomo.co.jp/service/imode/make/content/browser/html/tag/utn.html

    describe "iモードIDと端末個体識別子を取得できたとき" do
      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy?guid=ON',
                                         'HTTP_USER_AGENT' => 'DoCoMo/1.0/SO503i/c10/TB/serXXXXXXXXXXX',
                                         'HTTP_X_DCMGUID' => '0123abC')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
      end
      
      it "#subscriberid でiモードIDを取得できること" do
        @mobile.subscriberid.should == '0123abC'
      end
            
      it "#deviceid で端末個体識別子を取得できること" do
        @mobile.deviceid.should == "XXXXXXXXXXX"
      end
      
      it "#ident でiモードIDを取得できること" do
        @mobile.ident.should == '0123abC'
      end
      
    end

    describe "端末個体識別子のみ取得できたとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'DoCoMo/1.0/SO503i/c10/TB/serXXXXXXXXXXX')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
      end
      
      it "#subscriberid は nil を返すこと" do
        @mobile.subscriberid.should be_nil
      end
      
      it "#deviceid で端末個体識別子を取得できること" do
        @mobile.deviceid.should == "XXXXXXXXXXX"
      end

      it "#ident で端末個体識別子を取得できること" do
        @mobile.ident.should == @mobile.deviceid
        @mobile.ident.should == "XXXXXXXXXXX"
      end
    end

    describe "iモードIDも端末個体識別子も取得できないとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'DoCoMo/1.0/N505i/c20/TB/W24H12')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
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

    describe "iモードIDのみ取得できたとき" do

      before(:each) do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'DoCoMo/1.0/N505i/c20/TB/W24H12',
                                         'HTTP_X_DCMGUID' => '0123abC')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
      end
      
      it "#subscriberid はiモードIDを返すこと" do
        @mobile.subscriberid.should == '0123abC'
      end
      
      it "#deviceid は nil を返すこと" do
        @mobile.deviceid.should be_nil
      end

      it "#ident はiモードIDを返すこと" do
        @mobile.ident.should == '0123abC'
      end
    end

  end

end
