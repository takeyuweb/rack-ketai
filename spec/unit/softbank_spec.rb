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

    describe "ディスプレイ情報を取得できること" do
      
      describe "既知の端末のとき" do 

        it "環境変数を優先すること" do
          @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                           'HTTP_USER_AGENT' => 'SoftBank/1.0/933SH/SHJ002[/Serial] Browser/NetFront/3.5 Profile/MIDP-2.0 Configuration/CLDC-1.1',
                                           'HTTP_X_JPHONE_DISPLAY' => '1024*768',
                                           'HTTP_X_JPHONE_COLOR' => 'C256')
          @mobile = Rack::Ketai::Carrier::Softbank.new(@env)
          display = @mobile.display
          display.should_not be_nil
          display.colors.should == 256
          display.width.should == 1024
          display.height.should == 768
          
          @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                           'HTTP_USER_AGENT' => 'SoftBank/1.0/933SH/SHJ002[/Serial] Browser/NetFront/3.5 Profile/MIDP-2.0 Configuration/CLDC-1.1')
          @mobile = Rack::Ketai::Carrier::Softbank.new(@env)
          display = @mobile.display
          display.should_not be_nil
          display.colors.should == 16777216
          display.width.should == 480
          display.height.should == 738
        end

      end

      describe "未知の端末のとき" do 

        it "環境変数から設定すること" do
          @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                           'HTTP_USER_AGENT' => 'SoftBank/1.0/100XX/SHJ002[/Serial] Browser/NetFront/3.5 Profile/MIDP-2.0 Configuration/CLDC-1.1',
                                           'HTTP_X_JPHONE_DISPLAY' => '1024*768',
                                           'HTTP_X_JPHONE_COLOR' => 'C256')
          @mobile = Rack::Ketai::Carrier::Softbank.new(@env)
          display = @mobile.display
          display.should_not be_nil
          display.colors.should == 256
          display.width.should == 1024
          display.height.should == 768
        end

        it "環境変数が無かったら慌てず騒がず nil を返す" do
          @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                           'HTTP_USER_AGENT' => 'SoftBank/1.0/100XX/SHJ002[/Serial] Browser/NetFront/3.5 Profile/MIDP-2.0 Configuration/CLDC-1.1')
          @mobile = Rack::Ketai::Carrier::Softbank.new(@env)
          display = @mobile.display
          display.should_not be_nil
          display.colors.should be_nil
          display.width.should be_nil
          display.height.should be_nil
        end

      end

    end

  end

  describe "#cache_size でキャッシュ容量を取得するとき" do
    
    it "データにないときは300KBに設定でOK" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'SoftBank/1.0/923SH/SHJ001/SN*************** Browser/NetFront/3.4 Profile/MIDP-2.0 Configuration/CLDC-1.1')
      mobile = Rack::Ketai::Carrier::Softbank.new(env)
      mobile.name.should == '923SH'
      mobile.cache_size.should == 300000
    end

    it "仕方ないので、データにあればそれを信用" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'SoftBank/2.0/944SH/SHJ001/SN*************** Browser/NetFront/3.5 Profile/MIDP-2.0 Configuration/CLDC-1.1')
      mobile = Rack::Ketai::Carrier::Softbank.new(env)
      mobile.name.should == '944SH'
      mobile.cache_size.should == 500000
    end
    
  end
  
  describe "#supports_cookie? を使うとき" do
    # Softbank のCookie対応状況
    # W型、3GC型機種のみ対応…C型、P型もサービス終了につき、
    # 現状はすべて対応のはず
    it "#supports_cookie? は true を返す" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'SoftBank/1.0/930SH/SHJ001[/Serial] Browser/NetFront/3.4 Profile/MIDP-2.0 Configuration/CLDC-1.1')
      mobile = Rack::Ketai::Carrier::Softbank.new(env)
      mobile.should be_respond_to(:supports_cookie?)
      mobile.should be_supports_cookie
    end
  end

  it 'スマートフォンではないこと' do
    env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                    'HTTP_USER_AGENT' => 'SoftBank/1.0/930SH/SHJ001[/Serial] Browser/NetFront/3.4 Profile/MIDP-2.0 Configuration/CLDC-1.1')
    mobile = Rack::Ketai::Carrier::Softbank.new(env)
    mobile.should_not be_smartphone
  end

end
