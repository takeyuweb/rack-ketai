# -*- coding: utf-8 -*-
require 'rack/ketai/carrier/docomo'
describe "Rack::Ketai::Carrier::*.valid_addr? を使うとき" do

  def from(carrier, addr)
    env = Rack::MockRequest.env_for('http://hoge.com/dummy',
                                    'HTTP_USER_AGENT' => 'DoCoMo/1.0/N505i/c20/TB/W24H12',
                                    'HTTP_X_DCMGUID' => '0123abC',
                                    'REMOTE_ADDR' => addr)
    carrier.new(env)
  end

  CIDRS = {
      :Docomo => %w(
210.153.84.0/24
210.136.161.0/24
210.153.86.0/24
124.146.174.0/24
124.146.175.0/24
202.229.176.0/24
202.229.177.0/24
202.229.178.0/24
),
      :Au => %w(
210.230.128.224/28
121.111.227.160/27
61.117.1.0/28
219.108.158.0/27
219.125.146.0/28
61.117.2.32/29
61.117.2.40/29
219.108.158.40/29
219.125.148.0/25
222.5.63.0/25
222.5.63.128/25
222.5.62.128/25
59.135.38.128/25
219.108.157.0/25
219.125.145.0/25
121.111.231.0/25
121.111.227.0/25
118.152.214.192/26
118.159.131.0/25
118.159.133.0/25
118.159.132.160/27
111.86.142.0/26
111.86.141.64/26
111.86.141.128/26
111.86.141.192/26
),
      :Softbank => %w(
123.108.237.0/27
202.253.96.224/27
210.146.7.192/26
210.175.1.128/25
)
  }.freeze

  it "キャリア指定のアドレス帯域からのアクセスであれば真を返すこと" do
    CIDRS.each do |carrier_name, cidrs|
      klass = Rack::Ketai::Carrier.const_get(carrier_name)
      cidrs.each do |cidr|
        addrs = IPAddr.new(cidr).to_range.to_a
        from(klass, addrs.first.to_s).should be_valid_addr
        from(klass, addrs[(addrs.size - 1)/2].to_s).should be_valid_addr
        from(klass, addrs.last.to_s).should be_valid_addr
      end
    end
  end
  
  it "キャリア指定のアドレス帯域からのアクセスでなければ偽を返すこと" do
    CIDRS.each do |carrier_name, cidrs|
      ([Rack::Ketai::Carrier::Docomo,
        Rack::Ketai::Carrier::Au,
        Rack::Ketai::Carrier::Softbank] - [Rack::Ketai::Carrier.const_get(carrier_name)]).each do |klass|
        cidrs.each do |cidr|
          addrs = IPAddr.new(cidr).to_range.to_a
          from(klass, addrs.first.to_s).should_not be_valid_addr
          from(klass, addrs[(addrs.size - 1)/2].to_s).should_not be_valid_addr
          from(klass, addrs.last.to_s).should_not be_valid_addr
        end
      end
    end
  end

end
