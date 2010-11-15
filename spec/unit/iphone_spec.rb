# -*- coding: utf-8 -*-
require 'rack/ketai/carrier/iphone'
describe "Rack::Ketai::Carrier::IPhone" do

  describe 'iPhoneでのアクセスのとき' do
    
    before(:each) do
      @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; ja-jp) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7',
                                       'REMOTE_ADDR' => '126.240.0.41')
      @mobile = Rack::Ketai::Carrier.load(@env)
    end

    it 'Rack::Ketai::Carrier::IPhone がセットされること' do
      @mobile.should be_is_a(Rack::Ketai::Carrier::IPhone)
    end

    it '携帯端末であること' do
      @mobile.should be_mobile
    end

    it 'スマートフォンであること' do
      @mobile.should be_smartphone
    end

    it "#supports_cookie? は true を返すこと" do
      @mobile.should be_respond_to(:supports_cookie?)
      @mobile.should be_supports_cookie
    end

    it "#valid_addr? は false を返すこと" do
      @mobile.should_not be_valid_addr
    end

  end

  describe 'iPodでのアクセスのとき' do
    
    before(:each) do
      @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'Mozilla/5.0 (iPod; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/3A100a Safari/419.3',
                                       'REMOTE_ADDR' => '126.240.0.41')
      @mobile = Rack::Ketai::Carrier.load(@env)
    end

    it 'Rack::Ketai::Carrier::IPhone がセットされること' do
      @mobile.should be_is_a(Rack::Ketai::Carrier::IPhone)
    end

    it '携帯端末であること' do
      @mobile.should be_mobile
    end

    it 'スマートフォンであること' do
      @mobile.should be_smartphone
    end

    it "#supports_cookie? は true を返すこと" do
      @mobile.should be_respond_to(:supports_cookie?)
      @mobile.should be_supports_cookie
    end

    it "#valid_addr? は false を返すこと" do
      @mobile.should_not be_valid_addr
    end

  end

end
