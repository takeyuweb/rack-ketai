# -*- coding: utf-8 -*-
require 'spec_helper'
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

    it "#name で機種名を取得できること" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => "DoCoMo/2.0 SH02A")
      mobile = Rack::Ketai::Carrier::Docomo.new(env)
      mobile.name.should == 'SH02A'
    end

    it "#cache_size でキャッシュサイズが取得できること" do
      {
        'DoCoMo/2.0 P903i' => 5 * 1000,
        'DoCoMo/2.0 F900i(c100;TJ)' => 100 * 1000,
        'DoCoMo/2.0 F900i(c100;TC;W22H12)' => 100 * 1000,
        'DoCoMo/2.0 P903i(c100;serXXXXXXXXXXXXXXX; iccxxxxxxxxxxxxxxxxxxxx)' => 100 * 1000,
        'DoCoMo/2.0 N06A3(c500;TB;W24H16)' => 500 * 1000,
        'DoCoMo/2.0 XXXX(c500;TB;W24H16)' => 500 * 1000  # 未知の端末でも
      }.each do |ua, cache_size|
        env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => ua)
        mobile = Rack::Ketai::Carrier::Docomo.new(env)
        mobile.cache_size.should == cache_size
      end
    end

    describe "種別判定" do
      let(:env){Rack::MockRequest.env_for('http://hoge.com/dummy',
                                          'HTTP_USER_AGENT' => "DoCoMo/2.0 SH02A")}
      let(:mobile){Rack::Ketai::Carrier::Docomo.new(env)}
      it '携帯端末であること' do
        mobile.should be_mobile
      end
      it 'フィーチャーフォンであること' do
        mobile.should be_featurephone
      end
      it 'スマートフォンではないこと' do
        mobile.should_not be_smartphone
      end
      it 'タブレットではないこと' do
        mobile.should_not be_smartphone
      end
    end
    

    describe "ディスプレイ情報を取得できること" do
      
      it "既知の端末のとき" do           
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => "DoCoMo/2.0 SH02A(c100;TB;W30H20)")
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
        display = @mobile.display
        display.should_not be_nil
        display.colors.should == 16777216
        display.width.should == 240
        display.height.should == 320
      end

      it "未知の端末のとき" do 
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'DoCoMo/2.0 XX01(c100;TB;W30H20)')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
        display = @mobile.display
        display.should_not be_nil
        display.colors.should be_nil
        display.width.should be_nil
        display.height.should be_nil
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

    it "#name で機種名を取得できること" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => "DoCoMo/1.0/SO502i")
      mobile = Rack::Ketai::Carrier::Docomo.new(env)
      mobile.name.should == 'SO502i'
    end
    
    it "#cache_size でキャッシュサイズが取得できること" do
      {
        'DoCoMo/1.0/F502i' => 5 * 1000,
        'DoCoMo/1.0/D503i/c10' => 10 * 1000,
        'DoCoMo/1.0/N504i/c10/TB' => 10 * 1000,
        'DoCoMo/1.0/SO506iS/c20/TB/W20H10' => 20 * 1000,
      }.each do |ua, cache_size|
        env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => ua)
        mobile = Rack::Ketai::Carrier::Docomo.new(env)
        mobile.cache_size.should == cache_size
      end
    end

    describe "ディスプレイ情報を取得できること" do
      
      it "既知の端末のとき" do
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => "DoCoMo/1.0/SO502i")
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
        display = @mobile.display
        display.should_not be_nil
        display.colors.should == 4
        display.width.should == 120
        display.height.should == 120
      end

      it "未知の端末のとき" do 
        @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                         'HTTP_USER_AGENT' => 'DoCoMo/1.0/X000i')
        @mobile = Rack::Ketai::Carrier::Docomo.new(@env)
        display = @mobile.display
        display.should_not be_nil
        display.colors.should be_nil
        display.width.should be_nil
        display.height.should be_nil
      end

    end

  end

  describe "#supports_cookie? を使うとき" do

    # iモードブラウザ 2.0から対応
    # といっても、iモードブラウザ 2.0かどうか判断するには
    # キャッシュサイズで調べるしかない（c500）
    # キャッシュが不明な場合は端末データベースから判断
    # （ただし信頼性が低いので最後の手段）

    it "Cookie対応機種なら true を返すこと" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'DoCoMo/2.0 F02B')
      mobile = Rack::Ketai::Carrier::Docomo.new(env)
      mobile.should be_respond_to(:supports_cookie?)
      mobile.should be_supports_cookie
    end
    
    it "Cookie未対応機種なら false を返すこと" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'DoCoMo/2.0 L06A')
      mobile = Rack::Ketai::Carrier::Docomo.new(env)
      mobile.should be_respond_to(:supports_cookie?)
      mobile.should_not be_supports_cookie
    end

    it "不明な機種でもキャッシュサイズがわかればそれを基に判断すること" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'DoCoMo/2.0 X00HOGE3(c500;TB;W24H15)')
      mobile = Rack::Ketai::Carrier::Docomo.new(env)
      mobile.should be_respond_to(:supports_cookie?)
      mobile.should be_supports_cookie

      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'DoCoMo/2.0 X00HOGE3(c100;TB;W24H15)')
      mobile = Rack::Ketai::Carrier::Docomo.new(env)
      mobile.should be_respond_to(:supports_cookie?)
      mobile.should_not be_supports_cookie
    end

    it "不明な機種でキャッシュサイズもわからないなら false を返すこと" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'DoCoMo/2.0 X00HOGE')
      mobile = Rack::Ketai::Carrier::Docomo.new(env)
      mobile.should be_respond_to(:supports_cookie?)
      mobile.should_not be_supports_cookie
    end

  end

end
