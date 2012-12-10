# -*- coding: utf-8 -*-
require 'spec_helper'
require 'kconv'
require 'rack/ketai/carrier/au'
describe Rack::Ketai::Carrier::Au::Filter, "内部エンコーディングに変換する時" do

  before(:each) do
    @filter = Rack::Ketai::Carrier::Au::Filter.new
  end
  
  it "POSTデータ中のSJISバイナリの絵文字を絵文字IDに変換すること" do
    Rack::Ketai::Carrier::Au::Filter::EMOJI_TO_EMOJIID.should_not be_empty
    Rack::Ketai::Carrier::Au::Filter::EMOJI_TO_EMOJIID.each do |emoji, emojiid|
      postdata = "message=" + CGI.escape("今日はいい".tosjis + emoji + "ですね。".tosjis)
      postdata.force_encoding('Shift_JIS') if postdata.respond_to?(:force_encoding)
      
      env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                      'HTTP_USER_AGENT' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0',
                                      :method => 'POST', 
                                      :input => postdata)
      env = @filter.inbound(env)
      request = Rack::Request.new(env)
      request.params['message'].should == '今日はいい[e:'+format("%03X", emojiid)+']ですね。'
    end
  end
  
end

describe Rack::Ketai::Carrier::Au::Filter, "外部エンコーディングに変換する時" do

  before(:each) do
    @filter = Rack::Ketai::Carrier::Au::Filter.new
  end

  # Rails 3.0.0+Ruby1.9.xのとき、bodyにeachの使えないStringが渡されてエラーになったので
  it "bodyにStringを受け取ってもよきにはからってくれること" do
    status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, 'String')
    body.should == ['String']
  end
  
  it "データ中の絵文字IDをSJISの絵文字コードに変換すること" do
    Rack::Ketai::Carrier::Au::Filter::EMOJI_TO_EMOJIID.should_not be_empty
    Rack::Ketai::Carrier::Au::Filter::EMOJI_TO_EMOJIID.each do |emoji, emojiid|
      resdata = "今日はいい".tosjis + emoji + "ですね。".tosjis

      status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ['今日はいい[e:'+format("%03X", emojiid)+']ですね。'])

      body[0].should == resdata
    end
  end

  it "Content-typeが指定なし,text/html, application/xhtml+xml 以外の時はフィルタを適用しないこと" do
    Rack::Ketai::Carrier::Au::Filter::EMOJI_TO_EMOJIID.should_not be_empty
    Rack::Ketai::Carrier::Au::Filter::EMOJI_TO_EMOJIID.each do |emoji, emojiid|
      internaldata = '今日はいい[e:'+format("%03X", emojiid)+']ですね。'
      %w(text/plain text/xml text/json application/json text/javascript application/rss+xml image/jpeg).each do |contenttype|
        status, headers, body = @filter.outbound(200, { "Content-Type" => contenttype }, [internaldata])
        body[0].should == internaldata
      end
    end
  end

  it "データ中に絵文字ID＝絵文字IDだが絵文字!=絵文字IDのIDが含まれているとき、正しく逆変換できること" do
    emoji = [0xF649].pack('n')
    emoji.force_encoding('Shift_JIS') if emoji.respond_to?(:force_encoding)
    resdata = "たとえば".tosjis+emoji+"「e-338 HAPPY FACE WITH OPEN MOUTH AND RAISED EYEBROWS」とか。".tosjis

    status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ["たとえば[e:338]「e-338 HAPPY FACE WITH OPEN MOUTH AND RAISED EYEBROWS」とか。"])
    
    body[0].should == resdata
  end

  it "データ中にauにはない絵文字IDが存在するとき、代替文字を表示すること" do
    resdata = "Soon[SOON]です".tosjis # soon

    status, headers, body = @filter.outbound(200, { "Content-Type" => "text/html"}, ['Soon[e:018]です'])
    
    body[0].should == resdata
  end
  
  it "Content-typeを適切に書き換えられること" do
    [
     [nil, nil],
     ['text/html', 'text/html; charset=shift_jis'],
     ['text/html; charset=utf-8', 'text/html; charset=shift_jis'],
     ['text/html;charset=utf-8', 'text/html;charset=shift_jis'],
     ['application/xhtml+xml', 'application/xhtml+xml; charset=shift_jis'],
     ['application/xhtml+xml; charset=utf-8', 'application/xhtml+xml; charset=shift_jis'],
     ['application/xhtml+xml;charset=utf-8', 'application/xhtml+xml;charset=shift_jis'],
     ['text/javascript', 'text/javascript'],
     ['text/json', 'text/json'],
     ['application/json', 'application/json'],
     ['text/javascript+json', 'text/javascript+json'],
     ['image/jpeg', 'image/jpeg'],
     ['application/octet-stream', 'application/octet-stream'],
    ].each do |content_type, valid_content_type|
      orig_content_type = content_type == nil ? nil : content_type.clone
      status, headers, body = @filter.outbound(200, { "Content-Type" => content_type}, ['適当な本文'])
      headers['Content-Type'].should == valid_content_type
      # 元の文字列に直接変更を加えない（Rails3.0でハッシュを使い回してるようだったので）
      content_type.should == orig_content_type
    end
  end

end

