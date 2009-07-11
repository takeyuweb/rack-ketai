#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

SCRIPT_ROOT = File.dirname(__FILE__)

# データソース取得
emoji4unicode_dir = File.join(SCRIPT_ROOT, 'tmp/emoji4unicode')
typecast_dir = File.join(SCRIPT_ROOT, 'tmp/typecast')
jpmobile_dir = File.join(SCRIPT_ROOT, 'tmp/jpmobile')

`svn export http://emoji4unicode.googlecode.com/svn/trunk/data/ #{emoji4unicode_dir}` unless File.directory?(emoji4unicode_dir)
`svn export http://typecastmobile.googlecode.com/svn/trunk/ #{typecast_dir}` unless File.directory?(typecast_dir)
`git clone git://github.com/darashi/jpmobile.git #{jpmobile_dir}` unless File.directory?(jpmobile_dir)

$LOAD_PATH.unshift File.join(jpmobile_dir, 'lib')

require 'yaml'

emoticons = YAML.load(File.read(File.join(typecast_dir, 'conf/emoticon.yaml')))

# {"docomo" => {"XXXX" => "name"}}

require 'rexml/document'
emoji4unicode = File.read(File.join(emoji4unicode_dir, 'emoji4unicode.xml'))
#docomo = File.read(File.join(emoji4unicode_dir, 'docomo/carrier_data.xml'))
#kddi = File.read(File.join(emoji4unicode, 'kddi/carrier_data.xml'))
#softbank = File.read(File.join(emoji4unicode, 'softbank/carrier_data.xml'))

doc = REXML::Document.new(emoji4unicode)

conv_table = {
  :docomo => { },
  :kddi => { },
  :softbank => { }
}

# UTF-8コードから各キャリアの文字コード
carrier = {
  :docomo => { },
  :kddi => { },
  :softbank => { }
}

emoji = {}

doc.each_element('//e') do |elem|
  id = elem.attributes['id']
  unicode = elem.attributes['unicode']
  docomo_code = elem.attributes['docomo']
  kddi_code = elem.attributes['kddi']
  softbank_code = elem.attributes['softbank']
  google_code = elem.attributes['google']
  name = elem.attributes['name']
  fallback = elem.attributes['text_fallback']

  emoji[id] = {
    :google_code => google_code,
    :name => name,
    :fallback => fallback,
    :unicode => unicode
  }

  if docomo_code
    codes = docomo_code.split(/\+/).collect{ |code| code =~ /([0-9A-F]+)/ ? $1 : nil }.compact
    conv_table[:docomo][id] = codes
  end

  if kddi_code
    codes = kddi_code.split(/\+/).collect{ |code| code =~ /([0-9A-F]+)/ ? $1 : nil }.compact
    conv_table[:kddi][id] = codes
  end

  if softbank_code
    codes = softbank_code.split(/\+/).collect{ |code| code =~ /([0-9A-F]+)/ ? $1 : nil }.compact
    conv_table[:softbank][id] = codes
  end
  
end

conv_table[:docomo].each do |k, v|
  next unless emoji[v]
  name = emoji[v][:fallback] || emoji[v][:name]
  google_code = emoji[v][:google_code]
end

# データを元に辞書作成
module Jpmobile
  module Emoticon
  end
end
require 'jpmobile/emoticon/docomo'
require 'jpmobile/emoticon/au'
require 'jpmobile/emoticon/softbank'
# EMOJI COMPATIBILITY SYMBOL
DOCOMO_SJIS_TO_UNICODE = Jpmobile::Emoticon::DOCOMO_SJIS_TO_UNICODE.dup
DOCOMO_SJIS_TO_UNICODE.merge!({
                                0xE6A6 => 0xF94A, # ぴ
                                0xE6A7 => 0xF94B, # あ
                                0xE6A8 => 0xF94C, # チケぴ
                                0xE6A9 => 0xF94D, # チケぴ
                                0xE6AA => 0xF94E, # 先行tel
                                0xE6AB => 0xF94F, # pコード
                                0xE6AF => 0xF953, # 映画
                                0xE6B0 => 0xF954, # ぴ
                                0xE6B4 => 0xF958, # まるぴ
                                0xE6B5 => 0xF959, # 四角ぴ
                                0xE6B6 => 0xF95a, # チェック
                                0xE6BB => 0xF95F, # f
                                0xE6BC => 0xF960, # d
                                0xE6BD => 0xF961, # s
                                0xE6BE => 0xF962, # c
                                0xE6BF => 0xF963, # r
                                0xE6C0 => 0xF964, # 白黒四角
                                0xE6C1 => 0xF965, # 黒四角
                                0xE6C2 => 0xF966, # 逆三角
                                0xE6C3 => 0xF967, # 4十字
                                0xE6C4 => 0xF968, # 3十字
                                0xE6C5 => 0xF969, # 2十字
                                0xE6C6 => 0xF96A, # 1十字
                                0xE6C7 => 0xF96B, # i
                                0xE6C8 => 0xF96C, # m
                                0xE6C9 => 0xF96D, # e
                                0xE6CA => 0xF96E, # ve
                                0xE6CB => 0xF96F, # 球
                                0xE6CC => 0xF970, # カード使用不可
                                0xE6CD => 0xF971  # チェックボックス
                              }.invert)
DOCOMO_UNICODE_TO_SJIS = DOCOMO_SJIS_TO_UNICODE.invert

AU_SJIS_TO_UNICODE = Jpmobile::Emoticon::AU_SJIS_TO_UNICODE.dup
AU_SJIS_TO_UNICODE.merge!(0xF48E => 0xEB89, # EZアプリJ
                          0xF48F => 0xEB8A, # EXアプリB
                          0xF490 => 0xEB8B, # EZ着うた
                          0xF491 => 0xEB8C, # EZナビMS
                          0xF492 => 0xEB8D, # WIN
                          0xF493 => 0xEB8E  # プレミアム
                          )
AU_UNICODE_TO_SJIS = AU_SJIS_TO_UNICODE.invert

SOFTBANK_UNICODE_TO_WEBCODE = Jpmobile::Emoticon::SOFTBANK_UNICODE_TO_WEBCODE.dup
SOFTBANK_WEBCODE_TO_UNICODE = SOFTBANK_UNICODE_TO_WEBCODE.invert

output = { }

# ******************************
# 各キャリア 絵文字コード -> eid
# 絵文字の組み合わせも対応
# ******************************
# Docomo/au SJIS
# Softbank UTF-8
output['docomo_sjisstr_to_emojiid'] = (<<-FILE)
# -*- coding: utf-8 -*-

# DoCoMo-SJISバイナリとemoji4unicodeのIDとのマッピング

# format("0x%03X", Rack::Ketai::Carrier::Docomo::Filter::EMOJI_TO_EMOJIID[[0xF995].pack('n*').force_encoding('SHIFT_JIS')])
#   => "0x19B" (わーい(嬉しい顔) : SJIS-F995)
# format("0x%03X", Rack::Ketai::Carrier::Docomo::Filter::EMOJI_TO_EMOJIID[[0xF8CA, 0xF994].pack('n*').force_encoding('SHIFT_JIS')])
#   => "0x4B8" (ラブホテル = ホテル+ハートたち(複数ハート) : SJIS-F8CA+SJIS-F994)

module Rack
  module Ketai
    module Carrier
      class Docomo
        class Filter
          EMOJI_TO_EMOJIID = {
FILE

unknown = false
emoji_table = { }
emojiid_table = { }
emoji.each do |id, data|
  next unless (codes = conv_table[:docomo][id]) && !codes.empty?
  docomo_unicodes = codes.collect{ |code| eval("0x#{code}") }

  docomo_sjiscodes = docomo_unicodes.collect do |docomo_unicode|
    docomo_sjiscode = DOCOMO_UNICODE_TO_SJIS[docomo_unicode]
    unless docomo_sjiscode
      puts format("%04X", docomo_unicode)
      unknown = true
    end
    docomo_sjiscode
  end

  if unknown
    puts docomo_unicodes.collect{ |docomo_unicode| format("0x%04X", docomo_unicode) }.join('+')
  else
    emojiid = id.to_i(16)
    emoji_table[docomo_sjiscodes] ||= emojiid
    emojiid_table[emojiid] = docomo_sjiscodes
  end
end
emoji_table.each do |codes, emojiid|
  output['docomo_sjisstr_to_emojiid'] += format(%Q{            ((sjisstr = #{ codes.inspect }.pack('n*')) && RUBY_VERSION >= '1.9.1' ? sjisstr.force_encoding('Shift_JIS') : sjisstr) => 0x%03X,\n}, emojiid)
end
output['docomo_sjisstr_to_emojiid'] += <<-EOF
          }

          # 単にEMOJI_TO_EMOJIID#index を使うと、
          # 1つの絵文字が複数のIDに割り当てられている（DoCoMo SJIS-F97A など）場合
          # 見つからなくなる
          # 逆にEMOJIID_TO_EMOJIだけだと複数絵文字の組み合わせによるものがめんどくさい（たぶん）
          EMOJIID_TO_EMOJI = {
EOF
emojiid_table.each do |emojiid, codes|
  output['docomo_sjisstr_to_emojiid'] += format(%Q{            0x%03X => ((sjisstr = #{ codes.inspect }.pack('n*')) && RUBY_VERSION >= '1.9.1' ? sjisstr.force_encoding('Shift_JIS') : sjisstr),\n}, emojiid)
end
output['docomo_sjisstr_to_emojiid'] += <<-EOF
          }

          # 1.8系、1.9系 互換性維持のため
          if RUBY_VERSION >= '1.9.0'
            def EMOJI_TO_EMOJIID.index(val)
              key(val)
            end
          end
        end
      end
    end
  end
end

EOF

if unknown
  puts "不明なコードがあります"
  exit 1
end

# au
output['au_sjisstr_to_emojiid'] = (<<-FILE)
# -*- coding: utf-8 -*-

# Au-SJISバイナリとemoji4unicodeのIDとのマッピング

# format("0x%03X", Rack::Ketai::Carrier::Au::Filter::EMOJI_TO_EMOJIID[[0xF6D5].pack('n*').force_encoding('SHIFT_JIS')])
#   => "0x19B" (顔1: SJIS-F6D5)

module Rack
  module Ketai
    module Carrier
      class Au
        class Filter
          EMOJI_TO_EMOJIID = {
FILE

unknown = false
emoji_table = { }
emojiid_table = { }
emoji.each do |id, data|
  next unless (codes = conv_table[:kddi][id]) && !codes.empty?
  au_unicodes = codes.collect{ |code| eval("0x#{code}") }

  au_sjiscodes = au_unicodes.collect do |au_unicode|
    au_sjiscode = AU_UNICODE_TO_SJIS[au_unicode]
    unless au_sjiscode
      puts format("%04X", au_unicode)
      unknown = true
    end
    au_sjiscode
  end

  if unknown
    puts au_unicodes.collect{ |au_unicode| format("0x%04X", au_unicode) }.join('+')
  else
    emojiid = id.to_i(16)
    emoji_table[au_sjiscodes] ||= emojiid
    emojiid_table[emojiid] = au_sjiscodes
  end
end
emoji_table.each do |codes, emojiid|
  output['au_sjisstr_to_emojiid'] += format(%Q{            ((sjisstr = #{ codes.inspect }.pack('n*')) && RUBY_VERSION >= '1.9.1' ? sjisstr.force_encoding('Shift_JIS') : sjisstr) => 0x%03X,\n}, emojiid)
end
output['au_sjisstr_to_emojiid'] += <<-EOF
          }

          # 単にEMOJI_TO_EMOJIID#index を使うと、
          # 1つの絵文字が複数のIDに割り当てられている（DoCoMo SJIS-F97A など）場合
          # 見つからなくなる
          # 逆にEMOJIID_TO_EMOJIだけだと複数絵文字の組み合わせによるものがめんどくさい（たぶん）
          EMOJIID_TO_EMOJI = {
EOF
emojiid_table.each do |emojiid, codes|
  output['au_sjisstr_to_emojiid'] += format(%Q{            0x%03X => ((sjisstr = #{ codes.inspect }.pack('n*')) && RUBY_VERSION >= '1.9.1' ? sjisstr.force_encoding('Shift_JIS') : sjisstr),\n}, emojiid)
end
output['au_sjisstr_to_emojiid'] += <<-EOF
          }

          # 1.8系、1.9系 互換性維持のため
          if RUBY_VERSION >= '1.9.0'
            def EMOJI_TO_EMOJIID.index(val)
              key(val)
            end
          end

        end
      end
    end
  end
end

EOF

if unknown
  puts "不明なコードがあります"
  exit 1
end


# softbank
output['softbank_utf8str_to_emojiid'] = (<<-FILE)
# -*- coding: utf-8 -*-

# Softbank-UTF8バイナリとemoji4unicodeのIDとのマッピング

# format("0x%03X", Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID[[0xE001].pack('U*')])
#   => "0x19B" (男の子: Unicode E001)
# format("0x%03X", Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID[[0xE04A, 0xE049].pack('U*')])
#   => "0x00F" (晴れときどきくもり = 晴れ+くもり : U+E04A+U+E049)

module Rack
  module Ketai
    module Carrier
      class Softbank
        class Filter
          EMOJI_TO_EMOJIID = {
FILE

unknown = false
emoji_table = { }
emojiid_table = { }
emoji.each do |id, data|
  next unless (codes = conv_table[:softbank][id]) && !codes.empty?
  softbank_unicodes = codes.collect{ |code| eval("0x#{code}") }

  emojiid = id.to_i(16)
  emoji_table[softbank_unicodes] ||= emojiid
  emojiid_table[emojiid] = softbank_unicodes
end
emoji_table.each do |codes, emojiid|
  output['softbank_utf8str_to_emojiid'] += format(%Q{            "%s" => 0x%03X,\n}, codes.pack('U*'), emojiid)
end
output['softbank_utf8str_to_emojiid'] += <<-EOF
          }

          # 単にEMOJI_TO_EMOJIID#index を使うと、
          # 1つの絵文字が複数のIDに割り当てられている（DoCoMo SJIS-F97A など）場合
          # 見つからなくなる
          # 逆にEMOJIID_TO_EMOJIだけだと複数絵文字の組み合わせによるものがめんどくさい（たぶん）
          EMOJIID_TO_EMOJI = {
EOF
emojiid_table.each do |emojiid, codes|
  output['softbank_utf8str_to_emojiid'] += format(%Q{            0x%03X => "%s",\n}, emojiid, codes.pack('U*'))
end
output['softbank_utf8str_to_emojiid'] += <<-EOF
          }

          # 1.8系、1.9系 互換性維持のため
          if RUBY_VERSION >= '1.9.0'
            def EMOJI_TO_EMOJIID.index(val)
              key(val)
            end
          end
          
        end
      end
    end
  end
end

EOF

if unknown
  puts "不明なコードがあります"
  exit 1
end

# 絵文字の代替テキストマップ
output['emojidata'] = (<<-FILE)
# -*- coding: utf-8 -*-

# Softbank-UTF8バイナリとemoji4unicodeのIDとのマッピング

# format("0x%03X", Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID[[0xE001].pack('U*')])
#   => "0x19B" (男の子: Unicode E001)
# format("0x%03X", Rack::Ketai::Carrier::Softbank::Filter::EMOJI_TO_EMOJIID[[0xE04A, 0xE049].pack('U*')])
#   => "0x00F" (晴れときどきくもり = 晴れ+くもり : U+E04A+U+E049)

module Rack
  module Ketai
    module Carrier
      class Abstract
        class Filter
          EMOJI_DATA = {
FILE

emoji.each do |id, data|
  emojiid = id.to_i(16)
  output['emojidata'] += format("            0x%03X => #{data.inspect},\n", emojiid)
end

output['emojidata'] += <<-EOF
          }

          # 1.8系、1.9系 互換性維持のため
          if RUBY_VERSION >= '1.9.0'
            def EMOJI_TO_EMOJIID.index(val)
              key(val)
            end
          end
          
        end
      end
    end
  end
end

EOF


#puts output['docomo_sjisstr_to_emojiid']
#puts output['au_sjisstr_to_emojiid']
#puts output['softbank_utf8str_to_emojiid']

require 'fileutils'
output.each do |fname, data|
  fname = fname.gsub(/\_/, '')
  dic_dir = File.join(SCRIPT_ROOT, '../lib/rack/ketai/carrier/emoji')
  FileUtils.mkdir(dic_dir) unless FileTest.directory?(dic_dir)
  File.open(File.join(dic_dir, "#{fname}.rb"), 'w') do |f|
    f.write data
  end
end

