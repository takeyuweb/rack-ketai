# -*- coding: utf-8 -*-
require 'spec_helper'
require 'rack/ketai/carrier/general'
describe Rack::Ketai::Carrier::General do

  before(:each) do
    @env = Rack::MockRequest.env_for('http://hoge.com/dummy')
    @carrier = Rack::Ketai::Carrier::General.new(@env)
  end
  
  it ":disable_filter オプションを指定しないか false を渡すとフィルタが実行されること" do
    options = { }
    response = [200, { }, ['']]
    mock_filter = mock(Rack::Ketai::Carrier::General::EmoticonFilter)
    mock_filter.should_receive(:inbound).once.with(@env).and_return(@env)
    mock_filter.should_receive(:outbound).once.with(*response).and_return(response)
    Rack::Ketai::Carrier::General::EmoticonFilter.should_receive(:new).at_least(1).with(options).and_return(mock_filter)
    @carrier.filtering(@env, options){ |env| response }

    options = { :disable_filter => false }
    response = [200, { }, ['']]
    mock_filter = mock(Rack::Ketai::Carrier::General::EmoticonFilter)
    mock_filter.should_receive(:inbound).once.with(@env).and_return(@env)
    mock_filter.should_receive(:outbound).once.with(*response).and_return(response)
    Rack::Ketai::Carrier::General::EmoticonFilter.should_receive(:new).at_least(1).with(options).and_return(mock_filter)
    @carrier.filtering(@env, options){ |env| response }.should == response
  end

  it ":disable_filter オプションに true を渡すと、フィルタが実行されないこと" do
    options = { :disable_filter => true }
    response = [200, { }, ['']]
    mock_filter = mock(Rack::Ketai::Carrier::General::EmoticonFilter)
    mock_filter.should_receive(:inbound).exactly(0)
    mock_filter.should_receive(:outbound).exactly(0)
    Rack::Ketai::Carrier::General::EmoticonFilter.should_receive(:new).any_number_of_times.with(options).and_return(mock_filter)
    @carrier.filtering(@env, options){ |env| response }.should == response
  end

end
