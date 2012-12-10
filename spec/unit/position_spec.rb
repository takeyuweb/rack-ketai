# -*- coding: utf-8 -*-
require 'spec_helper'
require 'rack/ketai/position'

describe "Rack::Ketai::Position" do

  describe "生成する際" do
    it "lat,lngをFloatで与えることができること" do
      position = Rack::Ketai::Position.new(:lat => 35.009888888889,
                                           :lng => 135.69322222222)
      format("%.10f", position.lat).should == "35.0098888889"
      format("%.10f", position.lng).should == "135.6932222222"
    end

    it "lat,lngを度分秒の配列で与えることができること" do
      position = Rack::Ketai::Position.new(:lat => [35, 0 ,35.6],
                                           :lng => [135, 41, 35.6])
      format("%.10f", position.lat).should == "35.0098888889"
      format("%.10f", position.lng).should == "135.6932222222"
    end

    it "lat,lngを度分秒の文字列" do
      position = Rack::Ketai::Position.new(:lat => "35.00.35.600",
                                           :lng => "135.41.35.600")
      format("%.10f", position.lat).should == "35.0098888889"
      format("%.10f", position.lng).should == "135.6932222222"
    end
  end
  
  describe "パラメータを取得する際" do 
    before(:each) do
      @position = Rack::Ketai::Position.new(:lat => 35.009888888889,
                                            :lng => 135.69322222222)
    end
    
    it "#lat, #lng 引数無しの時はwgs84" do
      format("%.10f", @position.lat).should == "35.0098888889"
      format("%.10f", @position.lng).should == "135.6932222222"
    end
    
    it "#lat, #lng 引数で測地系を指定" do
      format("%.10f", @position.lat(:wgs84)).should == "35.0098888889"
      format("%.10f", @position.lng(:wgs84)).should == "135.6932222222"
      
      format("%.10f", @position.lat(:tokyo97)).should == "35.0066762382"
      format("%.10f", @position.lng(:tokyo97)).should == "135.6960795432"
    end
  end

end
