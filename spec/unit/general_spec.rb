# -*- coding: utf-8 -*-
require 'rack/ketai/carrier/general'
describe "Rack::Ketai::Carrier::General" do

  describe 'PCでのアクセスのとき' do
    
    before(:each) do
      @env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                       'HTTP_USER_AGENT' => 'Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12 ( .NET CLR 3.5.30729; .NET4.0E)',
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

    it 'Rack::Ketai::Carrier::General がセットされること' do
      @mobile.should be_is_a(Rack::Ketai::Carrier::General)
    end

    it '携帯端末でないこと' do
      @mobile.should_not be_mobile
    end

    it 'スマートフォンでないこと' do
      @mobile.should_not be_smartphone
    end

  end

end
