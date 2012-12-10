# -*- coding: utf-8 -*-
require 'spec_helper'
require 'rack/ketai/carrier/android'
describe "Rack::Ketai::Carrier::Android" do

  describe 'Android 2.1 でのアクセスのとき' do
    
    before(:each) do
      @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'Mozilla/5.0 (Linux; U; Android 2.1-update1; ja-jp; SonyEricssonSO-01B Build/2.0.B.0.138) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17',
                                       'REMOTE_ADDR' => '110.160.154.44')
      @mobile = Rack::Ketai::Carrier.load(@env)
    end

    it 'PC向け絵文字フィルタが適用されること' do
      mock_app = mock('App')
      mock_app.should_receive(:call).twice do |env|
        [200, { "Content-Type" => "text/html"}, ["今日は良い天気ですね[e:000]"]]
      end

      middleware = Rack::Ketai::Middleware.new(mock_app, {})
      middleware.call(@env)[2].should == ['今日は良い天気ですね[e:000]']

      middleware = Rack::Ketai::Middleware.new(mock_app, { :emoticons_path => '/path-to/emoticons' })
      middleware.call(@env)[2].should == ['今日は良い天気ですね<img src="/path-to/emoticons/sun.gif" />']
    end

    it 'Rack::Ketai::Carrier::Android がセットされること' do
      @mobile.should be_is_a(Rack::Ketai::Carrier::Android)
    end

    it '携帯端末であること' do
      @mobile.should be_mobile
    end

    it 'フィーチャーフォンでないこと' do
      @mobile.should_not be_featurephone
    end

    it 'スマートフォンであること' do
      @mobile.should be_smartphone
    end

    it 'タブレットでないこと' do
      @mobile.should_not be_tablet
    end

    it "#supports_cookie? は true を返すこと" do
      @mobile.should be_respond_to(:supports_cookie?)
      @mobile.should be_supports_cookie
    end

    it "#valid_addr? は false を返すこと" do
      @mobile.should_not be_valid_addr
    end

  end

  describe 'Androidタブレットでのアクセスのとき' do
    
    before(:each) do
      @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'Mozilla/5.0 (Linux; U; Android 4.0.3; ja-jp; Sony Tablet S Build/TISU0R0110) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30',
                                       'REMOTE_ADDR' => '211.2.176.39')
      @mobile = Rack::Ketai::Carrier.load(@env)
    end

    it '携帯端末であること' do
      @mobile.should be_mobile
    end

    it 'フィーチャーフォンでないこと' do
      @mobile.should_not be_featurephone
    end

    it 'スマートフォンでないこと' do
      @mobile.should_not be_smartphone
    end

    it 'タブレットであること' do
      @mobile.should be_tablet
    end

  end

  describe 'GalaxyTabでのアクセスのとき' do
    
    before(:each) do
      @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'Mozilla/5.0 (Linux; U; Android 2.2; ja-jp; SC-01C Build/FROYO)
AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
                                       'REMOTE_ADDR' => '211.2.176.39')
      @mobile = Rack::Ketai::Carrier.load(@env)
    end

    it '携帯端末であること' do
      @mobile.should be_mobile
    end

    it 'フィーチャーフォンでないこと' do
      @mobile.should_not be_featurephone
    end

    it 'スマートフォンでないこと' do
      @mobile.should_not be_smartphone
    end

    it 'タブレットであること' do
      @mobile.should be_tablet
    end

  end


end
