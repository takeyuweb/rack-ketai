# -*- coding: utf-8 -*-
require 'kconv'
require 'rack/ketai/carrier/softbank'
describe Rack::Ketai::Carrier::Softbank::Filter, "内部フィルタを適用する時" do

  before(:each) do
    @filter = Rack::Ketai::Carrier::Softbank::Filter.new
  end
  
  it "POSTデータ中のUTF-8バイナリの絵文字を絵文字IDに変換すること" do
    Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID.should_not be_empty
    Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID.each do |emoji, emojiid|
      postdata = CGI.escape("message=今日はいい" + emoji + "ですね。")
      postdata.force_encoding('UTF-8') if postdata.respond_to?(:force_encoding)
      
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'Softbank/2.0 P903i',
                                      :input => postdata)
      env = @filter.inbound(env)
      request = Rack::Request.new(env)
      request.params['message'].should == '今日はいい[e:'+format("%03X", emojiid)+']ですね。'
    end
  end

  it "POSTデータ中のウェブコードの絵文字を絵文字IDに変換すること" do
    Rack::Ketai::Carrier::Softbank::Filter::WEBCODE_TO_EMOJI.should_not be_empty
    Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID.should_not be_empty
    Rack::Ketai::Carrier::Softbank::Filter::WEBCODE_TO_EMOJI.each do |webcode, emoji|
      emojiid = Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID[emoji]
      postdata = CGI.escape("message=今日はいい\x1B$" + webcode + "\x0Fですね。")
      postdata.force_encoding('UTF-8') if postdata.respond_to?(:force_encoding)
      
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'Softbank/2.0 P903i',
                                      :input => postdata)
      env = @filter.inbound(env)
      request = Rack::Request.new(env)
      request.params['message'].should == '今日はいい[e:'+format("%03X", emojiid)+']ですね。'
    end
  end

  it "POSTデータ中の連続するウェブコードの絵文字を絵文字IDに変換すること" do
    postdata = CGI.escape("message=今日の天気は\x1B$Gji\x0Fです\x1B$ON\x0F")
    postdata.force_encoding('UTF-8') if postdata.respond_to?(:force_encoding)
    
    env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                    'HTTP_USER_AGENT' => 'Softbank/2.0 P903i',
                                    :input => postdata)
    env = @filter.inbound(env)
    request = Rack::Request.new(env)
    request.params['message'].should == '今日の天気は[e:00F]です[e:B60]'
  end
  
end

describe Rack::Ketai::Carrier::Softbank::Filter, "外部フィルタを適用する時" do

  before(:each) do
    @filter = Rack::Ketai::Carrier::Softbank::Filter.new
  end
  
  it "データ中の絵文字IDをウェブコードに変換すること" do
    Rack::Ketai::Carrier::Softbank::Filter::WEBCODE_TO_EMOJI.should_not be_empty
    Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID.should_not be_empty
    Rack::Ketai::Carrier::Softbank::Filter::WEBCODE_TO_EMOJI.each do |webcode, emoji|
      emojiid = Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID[emoji]
      resdata = "今日はいい\x1B$#{webcode}\x0Fですね。"

      status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ['今日はいい[e:'+format("%03X", emojiid)+']ですね。'])

      body[0].should == resdata
    end

    resdata = "今日の天気は\x1B$Gj\x0F\x1B$Gi\x0Fです\x1B$ON\x0F"
    status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ['今日の天気は[e:00F]です[e:B60]'])
    body[0].should == resdata
  end

  it "データ中に絵文字ID＝絵文字IDだが絵文字≠絵文字IDのIDが含まれているとき、正しく逆変換できること" do
    emoji = [0xF649].pack('n')
    resdata = "たとえば\x1B$P*\x0F「e-33E RELIEVED FACE」とか。"

    status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ["たとえば[e:33E]「e-33E RELIEVED FACE」とか。"])
    
    body[0].should == resdata
  end

  it "データ中にSoftBankにはない絵文字IDが存在するとき、代替文字を表示すること" do
    resdata = "Soon[SOON]です" # soon

    status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ['Soon[e:018]です'])
    
    body[0].should == resdata
  end
  
end
