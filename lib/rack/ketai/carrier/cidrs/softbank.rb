# -*- coding: utf-8 -*-
# http://creation.mb.softbank.jp/web/web_ip.html
# 2012.12.10時点

Rack::Ketai::Carrier::Softbank::CIDRS = %w(
123.108.237.112/28
123.108.239.224/28
202.253.96.144/28
202.253.99.144/28
210.228.189.188/30
).collect{ |cidr| IPAddr.new(cidr) }
