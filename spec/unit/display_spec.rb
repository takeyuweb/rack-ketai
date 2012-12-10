# -*- coding: utf-8 -*-
require 'spec_helper'
require 'rack/ketai/display'
describe "Rack::Ketai::Display" do

  before(:each) do
    @display1 = Rack::Ketai::Display.new
    @display2 = Rack::Ketai::Display.new(:colors => 256, :width => 240, :height => 360)
  end

  it "#colors で色数を取得可能なこと、未設定ならnil" do
    @display1.colors.should be_nil
    @display2.colors.should == 256
  end

  it "#width でブラウザ横幅を取得可能なこと、未設定ならnil" do
    @display1.width.should be_nil
    @display2.width.should == 240
  end

  it "#height でブラウザ縦幅を取得可能なこと、未設定ならnil" do
    @display1.height.should be_nil
    @display2.height.should == 360
  end
  
end
