# -*- coding: utf-8 -*-
require 'kconv'
require 'rack/ketai/carrier/general'

describe Rack::Ketai::Carrier::General::EmoticonFilter, "外部フィルタを適用する時" do

  before(:each) do
    @filter = Rack::Ketai::Carrier::General::EmoticonFilter.new(:emoticons_path => '/images/emoticons')
  end
  
  it "emoticons_path が与えられないときはなにもしないこと" do
    filter = Rack::Ketai::Carrier::General::EmoticonFilter.new
    Rack::Ketai::Carrier::General::EmoticonFilter::EMOJIID_TO_TYPECAST_EMOTICONS.each do |emojiid, filenames|
      str = '今日はいい[e:'+format("%03X", emojiid)+']ですね。'
      resdata = str

      status, headers, body = filter.outbound(200, { "Content-Type" => "text/html"}, [str])

      body[0].should == resdata
    end
    filter = Rack::Ketai::Carrier::General::EmoticonFilter.new(:emoticons_path => '')
    Rack::Ketai::Carrier::General::EmoticonFilter::EMOJIID_TO_TYPECAST_EMOTICONS.each do |emojiid, filenames|
      str = '今日はいい[e:'+format("%03X", emojiid)+']ですね。'
      resdata = str

      status, headers, body = filter.outbound(200, { "Content-Type" => "text/html"}, [str])

      body[0].should == resdata
    end
  end

  it "データ中の絵文字IDをimgタグに変換すること" do
    Rack::Ketai::Carrier::General::EmoticonFilter::EMOJIID_TO_TYPECAST_EMOTICONS.each do |emojiid, filenames|
      tag = filenames.collect{ |filename| "<img src=\"/images/emoticons/#{filename}.gif\" />" }.join('')
      resdata = "今日はいい#{tag}ですね。"

      status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ['今日はいい[e:'+format("%03X", emojiid)+']ですね。'])

      body[0].should == resdata
    end
  end

  it "データ中に絵文字ID＝絵文字IDだが絵文字≠絵文字IDのIDが含まれているとき、正しく逆変換できること" do
    resdata = "たとえば<img src=\"/images/emoticons/happy01.gif\" />「e-330 HAPPY FACE WITH OPEN MOUTH」とか。"

    status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ["たとえば[e:330]「e-330 HAPPY FACE WITH OPEN MOUTH」とか。"])
    
    body[0].should == resdata
  end
  
  it "データ中にTypepad絵文字にはない絵文字IDが存在するとき、代替文字を表示すること" do
    resdata = "黒い矢印[#{[0x2190].pack('U')}]です" # 左黒矢印

    status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ['黒い矢印[e:AFB]です'])
    
    body[0].should == resdata
  end
  
  it "Content-typeがhtmlでないときには変換しないこと（未設定の場合除く）" do
    emojiid = 0x00F
    filenames = ["sun","cloud"]
    str = '今日はいい[e:'+format("%03X", emojiid)+']ですね。'
    tag = filenames.collect{ |filename| "<img src=\"/images/emoticons/#{filename}.gif\" />" }.join('')
    
    %w(text/plain text/xml text/json application/json text/javascript application/rss+xml).each do |contenttype|
      resdata = str
    
      status, headers, body = @filter.outbound(200, { "Content-Type" => contenttype}, ['今日はいい[e:'+format("%03X", emojiid)+']ですね。'])
      
      body[0].should == resdata
    end

    %w(text/html text/xhtml application/xhtml+xml).each do |contenttype|
      resdata = '今日はいい'+tag+'ですね。'
    
      status, headers, body = @filter.outbound(200, { "Content-Type" => contenttype}, ['今日はいい[e:'+format("%03X", emojiid)+']ですね。'])
      
      body[0].should == resdata
    end

    resdata = '今日はいい'+tag+'ですね。'
    status, headers, body = @filter.outbound(200, { "Content-Type" => ''}, ['今日はいい[e:'+format("%03X", emojiid)+']ですね。'])
    body[0].should == resdata

    resdata = '今日はいい'+tag+'ですね。'
    status, headers, body = @filter.outbound(200, {}, ['今日はいい[e:'+format("%03X", emojiid)+']ですね。'])
    body[0].should == resdata

  end

end
