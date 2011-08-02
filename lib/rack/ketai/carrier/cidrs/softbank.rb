# -*- coding: utf-8 -*-
# http://creation.mb.softbank.jp/web/web_ip.html
# 2011.8.2時点

Rack::Ketai::Carrier::Softbank::CIDRS = %w(
123.108.237.0/27
202.253.96.224/27
210.146.7.192/26
).collect{ |cidr| IPAddr.new(cidr) }
