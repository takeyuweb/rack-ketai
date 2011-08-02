# -*- coding: utf-8 -*-
# http://www.nttdocomo.co.jp/service/imode/make/content/ip/index.html
# 2011.8.2時点

Rack::Ketai::Carrier::Docomo::CIDRS = %w(
210.153.84.0/24
210.136.161.0/24
210.153.86.0/24
124.146.174.0/24
124.146.175.0/24
202.229.176.0/24
202.229.177.0/24
202.229.178.0/24
).collect{ |cidr| IPAddr.new(cidr) }
