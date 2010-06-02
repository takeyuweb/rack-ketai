#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# ke-tai.org の携帯端末スペック一覧をダウンロードして加工

require 'open-uri'
require 'nkf'
require 'csv'
require 'tempfile'

csvdata = NKF.nkf('-Sw', open('http://ke-tai.org/moblist/csv_down.php').read)
lines = csvdata.gsub(/\r?\n/, "\n").split(/\n/).collect{ |str| str.gsub(/([^,])"([^,])/u, '\1&quot;\2') }
lines.slice!(0, 2)

table = {}

# CSV
# [ 0] 連番
# [ 1] メーカ名
# [ 2] 機種名
# [ 3] 機種略名
# [ 4] ユーザエージェント
# [ 5] タイプ１
# [ 6] タイプ２
# [ 7] ブラウザ幅(x)
# [ 8] ブラウザ高さ(y)
# [ 9] 表示カラー数
# [10] ブラウザキャッシュ
# [11] GIF
# [12] JPG
# [13] PNG
# [14] Flash
# [15] Flashバージョン
# [16] Flashワークメモリ
# [17] Javaアプリ
# [18] BREW
# [19] HTML
# [20] SSL
# [21] ログイン
# [22] クッキー
# [23] CSS
# [24] GPS
# [25] 発売日

enable_row_indexes = [1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
# [ 0] メーカ名
# [ 1] 機種名
# [ 2] ユーザエージェント
# [ 3] タイプ１
# [ 4] タイプ２
# [ 5] ブラウザ幅(x)
# [ 6] ブラウザ高さ(y)
# [ 7] 表示カラー数
# [ 8] ブラウザキャッシュ
# [ 9] GIF
# [10] JPG
# [11] PNG
# [12] Flash
# [13] Flashバージョン
# [14] Flashワークメモリ
# [15] Javaアプリ
# [16] BREW
# [17] HTML
# [18] SSL
# [19] ログイン
# [20] クッキー
# [21] CSS
# [22] GPS
# [23] 発売日

CSV::Reader.parse(lines.join("\n")).each do |row|
  row.slice!(26)
  

  table[row[1]] ||= { }
  table[row[1]][row[3]] ||= row.values_at(*enable_row_indexes)
end

[
 %w(DoCoMo Docomo docomo.rb),
 %w(au Au au.rb),
 %w(SoftBank Softbank softbank.rb)
].each do |carrier, classname, filename|
  File.open(File.join(File.dirname(__FILE__), '../lib/rack/ketai/carrier/specs', filename), 'w') do |f|
    f.write "Rack::Ketai::Carrier::#{classname}::SPECS = #{ table[carrier].inspect }"
  end
end
