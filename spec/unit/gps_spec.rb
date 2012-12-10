# -*- coding: utf-8 -*-
require 'spec_helper'
require 'rack/ketai/carrier/docomo'

describe "位置情報を取得するとき" do
  describe "DoCoMo端末で" do

    it "#position でGPS位置情報が取得できること" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy?lat=%2B35.00.35.600&lon=%2B135.41.35.600&geo=wgs84&x-acc=3',
                                      'HTTP_USER_AGENT' => 'DoCoMo/2.0 P903i(c10)')
      mobile = Rack::Ketai::Carrier::Docomo.new(env)
      position = mobile.position
      position.should be_instance_of(Rack::Ketai::Position)
      format("%.10f", position.lat).should == "35.0098888889"
      format("%.10f", position.lng).should == "135.6932222222"
    end

    it "取得に失敗したら #position が nil に設定されること" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'DoCoMo/2.0 P903i(c10)')
      mobile = Rack::Ketai::Carrier::Docomo.new(env)
      mobile.position.should be_nil
    end
  end

  describe "au端末で" do

    describe "#position でGPS位置情報が" do
      it "WGS84+度分秒単位で渡された場合に取得できること" do
        env = Rack::MockRequest.env_for('http://hoge.com/dummy?var=1&alt=33&time=20100913142300&smaj=104&smin=53&vert=41&majaa=96&fm=2&unit=0&lat=%2B35.00.35.60&lon=%2B135.41.35.60&datum=0',
                                        'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
        mobile = Rack::Ketai::Carrier::Au.new(env)
        position = mobile.position
        position.should be_instance_of(Rack::Ketai::Position)
        format("%.10f", position.lat).should == "35.0098888889"
        format("%.10f", position.lng).should == "135.6932222222"

        # +/-が省略
        env = Rack::MockRequest.env_for('http://hoge.com/dummy?var=1&alt=33&time=20100913142300&smaj=104&smin=53&vert=41&majaa=96&fm=2&unit=0&lat=35.00.35.60&lon=135.41.35.60&datum=0',
                                        'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
        mobile = Rack::Ketai::Carrier::Au.new(env)
        position = mobile.position
        position.should be_instance_of(Rack::Ketai::Position)
        format("%.10f", position.lat).should == "35.0098888889"
        format("%.10f", position.lng).should == "135.6932222222"
      end

      it "WGS84+度単位で渡された場合に取得できること" do
        env = Rack::MockRequest.env_for('http://hoge.com/dummy?var=1&alt=33&time=20100913142300&smaj=104&smin=53&vert=41&majaa=96&fm=2&unit=1&lat=%2B35.00989&lon=%2B135.69322&datum=0',
                                        'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
        mobile = Rack::Ketai::Carrier::Au.new(env)
        position = mobile.position
        position.should be_instance_of(Rack::Ketai::Position)
        format("%.10f", position.lat).should == "35.0098900000"
        format("%.10f", position.lng).should == "135.6932200000"

        # +/-が省略
        env = Rack::MockRequest.env_for('http://hoge.com/dummy?var=1&alt=33&time=20100913142300&smaj=104&smin=53&vert=41&majaa=96&fm=2&unit=1&lat=35.00989&lon=135.69322&datum=0',
                                        'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
        mobile = Rack::Ketai::Carrier::Au.new(env)
        position = mobile.position
        position.should be_instance_of(Rack::Ketai::Position)
        format("%.10f", position.lat).should == "35.0098900000"
        format("%.10f", position.lng).should == "135.6932200000"
      end

      it "TOKYO97+度分秒単位で渡された場合に取得できること" do
        env = Rack::MockRequest.env_for('http://hoge.com/dummy?var=1&alt=33&time=20100913142300&smaj=104&smin=53&vert=41&majaa=96&fm=2&unit=0&lat=%2B35.00.35.60&lon=%2B135.41.35.60&datum=1',
                                        'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
        mobile = Rack::Ketai::Carrier::Au.new(env)
        position = mobile.position
        position.should be_instance_of(Rack::Ketai::Position)
        format("%.10f", position.lat).should == "35.0131010819"
        format("%.10f", position.lng).should == "135.6903650621"

        # +/-が省略
        env = Rack::MockRequest.env_for('http://hoge.com/dummy?var=1&alt=33&time=20100913142300&smaj=104&smin=53&vert=41&majaa=96&fm=2&unit=0&lat=35.00.35.60&lon=135.41.35.60&datum=1',
                                        'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
        mobile = Rack::Ketai::Carrier::Au.new(env)
        position = mobile.position
        position.should be_instance_of(Rack::Ketai::Position)
        format("%.10f", position.lat).should == "35.0131010819"
        format("%.10f", position.lng).should == "135.6903650621"
      end

      it "TOKYO97+度単位で渡された場合に取得できること" do
        env = Rack::MockRequest.env_for('http://hoge.com/dummy?var=1&alt=33&time=20100913142300&smaj=104&smin=53&vert=41&majaa=96&fm=2&unit=1&lat=%2B35.00989&lon=%2B135.69322&datum=1',
                                        'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
        mobile = Rack::Ketai::Carrier::Au.new(env)
        position = mobile.position
        position.should be_instance_of(Rack::Ketai::Position)
        format("%.10f", position.lat).should == "35.0131021928"
        format("%.10f", position.lng).should == "135.6903628401"

        # +/-が省略
        env = Rack::MockRequest.env_for('http://hoge.com/dummy?var=1&alt=33&time=20100913142300&smaj=104&smin=53&vert=41&majaa=96&fm=2&unit=1&lat=35.00989&lon=135.69322&datum=1',
                                        'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
        mobile = Rack::Ketai::Carrier::Au.new(env)
        position = mobile.position
        position.should be_instance_of(Rack::Ketai::Position)
        format("%.10f", position.lat).should == "35.0131021928"
        format("%.10f", position.lng).should == "135.6903628401"
      end

    end

    it "取得に失敗したら #position が nil に設定されること" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0')
      mobile = Rack::Ketai::Carrier::Au.new(env)
      mobile.position.should be_nil
    end
  end

  describe "Softbank端末(3GC)で" do

    it "#position でGPS位置情報(WGS84)が取得できること" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy?pos=N35.00.35.60E135.41.35.60&geo=wgs84&x-acr=3',
                                      'HTTP_USER_AGENT' => 'SoftBank/1.0/824T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1')
      mobile = Rack::Ketai::Carrier::Softbank.new(env)
      position = mobile.position
      position.should be_instance_of(Rack::Ketai::Position)
      format("%.10f", position.lat).should == "35.0098888889"
      format("%.10f", position.lng).should == "135.6932222222"
    end

    it "#position でGPS位置情報(TOKYO)が取得できること" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy?pos=N35.00.35.60E135.41.35.60&geo=tokyo&x-acr=3',
                                      'HTTP_USER_AGENT' => 'SoftBank/1.0/824T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1')
      mobile = Rack::Ketai::Carrier::Softbank.new(env)
      position = mobile.position
      position.should be_instance_of(Rack::Ketai::Position)
      format("%.10f", position.lat).should == "35.0131010819"
      format("%.10f", position.lng).should == "135.6903650621"
    end


    it "取得に失敗したら #position が nil に設定されること" do
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'SoftBank/1.0/824T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1')
      mobile = Rack::Ketai::Carrier::Softbank.new(env)
      mobile.position.should be_nil
    end
  end

end

