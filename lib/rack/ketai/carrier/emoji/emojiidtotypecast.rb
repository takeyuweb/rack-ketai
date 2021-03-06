# -*- coding: utf-8 -*-

# emoji4unicode と TypeCast絵文字アイコン名との対応表

# Rack::Ketai::Carrier::General::EmoticonFilter::EMOJIID_TO_TYPECAST_EMOTICONS[0x000]
#   => ["sun"]
# Rack::Ketai::Carrier::General::EmoticonFilter::EMOJIID_TO_TYPECAST_EMOTICONS[0x00F]
#   => ["sun", "cloud"] (晴れときどきくもり = 晴れ+くもり)

module Rack
  module Ketai
    module Carrier
      class General
        class EmoticonFilter
          EMOJIID_TO_TYPECAST_EMOTICONS = {
              0xB83 => ["enter"],
  0x7EE => ["yacht"],
  0xE12 => ["by-d"],
  0x4DC => ["moneybag"],
  0x830 => ["three"],
  0x000 => ["sun"],
  0x042 => ["maple"],
  0x7EF => ["car"],
  0xE13 => ["d-point"],
  0x4DD => ["dollar"],
  0xB84 => ["clear"],
  0x831 => ["four"],
  0x001 => ["cloud"],
  0x7F0 => ["run"],
  0xE14 => ["appli01"],
  0xB85 => ["search"],
  0x832 => ["five"],
  0xB44 => ["fullmoon"],
  0x002 => ["rain"],
  0xE15 => ["appli02"],
  0xB86 => ["key"],
  0x833 => ["six"],
  0x003 => ["snow"],
  0x4E0 => ["dollar"],
  0xB04 => ["sign01"],
  0xB87 => ["key"],
  0x834 => ["seven"],
  0x522 => ["pocketbell"],
  0x004 => ["thunder"],
  0xB05 => ["sign02"],
  0x835 => ["eight"],
  0x523 => ["telephone"],
  0x005 => ["typhoon"],
  0x1D0 => ["dog"],
  0x359 => ["sad"],
  0x4E2 => ["yen"],
  0xB06 => ["sign03"],
  0x836 => ["nine"],
  0x524 => ["telephone"],
  0xB48 => ["ban"],
  0x006 => ["mist"],
  0x7F5 => ["gasstation"],
  0x35A => ["angry"],
  0x4E3 => ["dollar"],
  0xB07 => ["sign04"],
  0xB8A => ["key"],
  0x190 => ["eye"],
  0x837 => ["zero"],
  0x525 => ["mobilephone"],
  0x007 => ["sprinkle"],
  0x7F6 => ["parking"],
  0xB08 => ["sign05"],
  0x191 => ["ear"],
  0x526 => ["phoneto"],
  0x008 => ["night"],
  0x7F7 => ["signaler"],
  0x980 => ["restaurant"],
  0x527 => ["memo"],
  0x009 => ["sun"],
  0x981 => ["cafe"],
  0xB8D => ["search"],
  0x528 => ["faxto"],
  0x00A => ["sun"],
  0x193 => ["kissmark"],
  0x982 => ["bar"],
  0xB0B => ["sign01"],
  0x529 => ["mail"],
  0x194 => ["bleah"],
  0x7FA => ["spa"],
  0x983 => ["beer"],
  0xB0C => ["heart01"],
  0x52A => ["mailto"],
  0x00C => ["sun"],
  0x195 => ["rouge"],
  0x984 => ["japanesetea"],
  0xB0D => ["heart02"],
  0xB90 => ["key"],
  0x04E => ["clover"],
  0x52B => ["mailto"],
  0x985 => ["bottle"],
  0xB0E => ["heart03"],
  0xB91 => ["recycle"],
  0x04F => ["cherry"],
  0x1D8 => ["dog"],
  0x7FC => ["carouselpony"],
  0x320 => ["angry"],
  0x52C => ["postoffice"],
  0x986 => ["wine"],
  0xB0F => ["heart04"],
  0xB92 => ["mail"],
  0x050 => ["banana"],
  0x1D9 => ["fish"],
  0x321 => ["sad"],
  0x52D => ["postoffice"],
  0x00F => ["sun","cloud"],
  0x198 => ["hairsalon"],
  0x987 => ["beer"],
  0xB10 => ["heart01"],
  0xB93 => ["rock"],
  0x051 => ["apple"],
  0x322 => ["wobbly"],
  0x52E => ["postoffice"],
  0x010 => ["night"],
  0x988 => ["bar"],
  0xB11 => ["heart02"],
  0xB94 => ["scissors"],
  0x1DB => ["foot"],
  0x7FF => ["fish"],
  0x323 => ["despair"],
  0x011 => ["newmoon"],
  0x19A => ["shadow"],
  0xB12 => ["heart01"],
  0xB95 => ["paper"],
  0x800 => ["karaoke"],
  0x012 => ["moon1"],
  0x19B => ["happy01"],
  0x324 => ["wobbly"],
  0x4EF => ["camera"],
  0xB13 => ["heart01"],
  0xB96 => ["punch"],
  0x1DD => ["chick"],
  0x801 => ["movie"],
  0xB55 => ["cute"],
  0x013 => ["moon2"],
  0x19C => ["happy01"],
  0x325 => ["coldsweats02"],
  0x4F0 => ["bag"],
  0xB14 => ["heart01"],
  0xB97 => ["good"],
  0x802 => ["movie"],
  0xB56 => ["flair"],
  0x014 => ["moon3"],
  0x19D => ["happy01"],
  0x326 => ["gawk"],
  0x4F1 => ["pouch"],
  0xB15 => ["heart01"],
  0x803 => ["music"],
  0x4B0 => ["house"],
  0xB57 => ["annoy"],
  0x015 => ["fullmoon"],
  0x19E => ["happy01"],
  0x327 => ["lovely"],
  0x4F2 => ["bell"],
  0xB16 => ["heart01"],
  0x1E0 => ["pig"],
  0x804 => ["art"],
  0x4B1 => ["house"],
  0xB58 => ["bomb"],
  0x016 => ["moon2"],
  0x328 => ["smile"],
  0x4F3 => ["door"],
  0xB17 => ["heart01"],
  0x805 => ["drama"],
  0x4B2 => ["building"],
  0x535 => ["present"],
  0xB59 => ["sleepy"],
  0x329 => ["bleah"],
  0xB18 => ["heart02"],
  0x806 => ["event"],
  0x4B3 => ["postoffice"],
  0x536 => ["pen"],
  0xB5A => ["impact"],
  0x018 => ["soon"],
  0x32A => ["bleah"],
  0xB19 => ["cute"],
  0x807 => ["ticket"],
  0x4B4 => ["hospital"],
  0x537 => ["chair"],
  0xB5B => ["sweat01"],
  0x019 => ["true"],
  0x32B => ["delicious"],
  0xB1A => ["heart"],
  0xB9D => ["paper"],
  0x05B => ["apple"],
  0x808 => ["slate"],
  0x4B5 => ["bank"],
  0x538 => ["pc"],
  0xB5C => ["sweat02"],
  0x01A => ["end"],
  0x32C => ["lovely"],
  0xB1B => ["spade"],
  0x539 => ["pencil"],
  0xB5D => ["dash"],
  0x01B => ["sandclock"],
  0x32D => ["lovely"],
  0x4B6 => ["atm"],
  0xB1C => ["diamond"],
  0xB9F => ["ok"],
  0x80A => ["game"],
  0x53A => ["clip"],
  0x01C => ["sandclock"],
  0x4B7 => ["hotel"],
  0xB1D => ["club"],
  0xBA0 => ["down"],
  0x4F9 => ["movie"],
  0x53B => ["bag"],
  0x01D => ["watch"],
  0x32F => ["happy02"],
  0x4B8 => ["hotel","heart04"],
  0xB1E => ["smoking"],
  0xBA1 => ["paper"],
  0xB60 => ["shine"],
  0x01E => ["clock"],
  0x330 => ["happy01"],
  0x4B9 => ["24hours"],
  0x4FB => ["flair"],
  0xB1F => ["nosmoking"],
  0xB61 => ["cute"],
  0x01F => ["clock"],
  0x331 => ["coldsweats01"],
  0x4BA => ["school"],
  0xBA3 => ["newmoon"],
  0xB20 => ["wheelchair"],
  0x020 => ["clock"],
  0x332 => ["happy02"],
  0x53E => ["hairsalon"],
  0xB62 => ["cute"],
  0x4FD => ["sign05"],
  0xB21 => ["free"],
  0x333 => ["smile"],
  0xB63 => ["newmoon"],
  0x021 => ["clock"],
  0xB22 => ["flag"],
  0x334 => ["happy02"],
  0x540 => ["memo"],
  0xB64 => ["newmoon"],
  0x022 => ["clock"],
  0x4FF => ["book"],
  0xB23 => ["danger"],
  0x7D0 => ["sports"],
  0x335 => ["happy01"],
  0x541 => ["memo"],
  0xB65 => ["newmoon"],
  0x023 => ["clock"],
  0x500 => ["book"],
  0x7D1 => ["baseball"],
  0x336 => ["happy01"],
  0xB66 => ["newmoon"],
  0x024 => ["clock"],
  0x813 => ["note"],
  0x501 => ["book"],
  0x7D2 => ["golf"],
  0x337 => ["happy01"],
  0xB67 => ["newmoon"],
  0x025 => ["clock"],
  0x814 => ["notes"],
  0x502 => ["book"],
  0xB26 => ["ng"],
  0x7D3 => ["tennis"],
  0x338 => ["happy01"],
  0x4C1 => ["ship"],
  0x026 => ["clock"],
  0x503 => ["book"],
  0xB27 => ["ok"],
  0x7D4 => ["soccer"],
  0x339 => ["weep"],
  0x4C2 => ["bottle"],
  0x545 => ["book"],
  0x027 => ["clock"],
  0xB28 => ["ng"],
  0x7D5 => ["ski"],
  0x33A => ["crying"],
  0x4C3 => ["fuji"],
  0x546 => ["book"],
  0x028 => ["clock"],
  0x505 => ["spa"],
  0xB29 => ["copyright"],
  0x7D6 => ["basketball"],
  0x33B => ["shock"],
  0x547 => ["book"],
  0x029 => ["clock"],
  0x506 => ["toilet"],
  0xB2A => ["tm"],
  0x7D7 => ["motorsports"],
  0x33C => ["bearing"],
  0x960 => ["fastfood"],
  0x548 => ["memo"],
  0x02A => ["clock"],
  0x507 => ["toilet"],
  0xB2B => ["secret"],
  0x7D8 => ["snowboard"],
  0x33D => ["pout"],
  0x961 => ["riceball"],
  0x02B => ["aries"],
  0x81A => ["notes"],
  0x508 => ["toilet"],
  0xB2C => ["recycle"],
  0x7D9 => ["run"],
  0x33E => ["confident"],
  0x962 => ["cake"],
  0x02C => ["taurus"],
  0xB2D => ["r-mark"],
  0x33F => ["sad"],
  0x963 => ["noodle"],
  0x02D => ["gemini"],
  0x7DA => ["snowboard"],
  0x81C => ["tv"],
  0xB2E => ["ban"],
  0x340 => ["think"],
  0x964 => ["bread"],
  0x4C9 => ["wrench"],
  0x02E => ["cancer"],
  0x1B7 => ["dog"],
  0xB2F => ["empty"],
  0x81D => ["cd"],
  0x341 => ["shock"],
  0x54D => ["book"],
  0x02F => ["leo"],
  0x1B8 => ["cat"],
  0x7DC => ["horse"],
  0xB30 => ["pass"],
  0x81E => ["cd"],
  0x342 => ["sleepy"],
  0x030 => ["virgo"],
  0x1B9 => ["snail"],
  0xB31 => ["full"],
  0x343 => ["catface"],
  0x4CC => ["shoe"],
  0xAF0 => ["upwardright"],
  0x54F => ["book"],
  0x031 => ["libra"],
  0x1BA => ["chick"],
  0x344 => ["coldsweats02"],
  0x4CD => ["shoe"],
  0xAF1 => ["downwardright"],
  0x032 => ["scorpius"],
  0x1BB => ["chick"],
  0x7DF => ["train"],
  0x50F => ["ribbon"],
  0x4CE => ["eyeglass"],
  0xAF2 => ["upwardleft"],
  0x033 => ["sagittarius"],
  0x1BC => ["penguin"],
  0x7E0 => ["subway"],
  0x345 => ["coldsweats02"],
  0x510 => ["present"],
  0x96A => ["noodle"],
  0x4CF => ["t-shirt"],
  0xAF3 => ["downwardleft"],
  0x552 => ["memo"],
  0x034 => ["capricornus"],
  0x1BD => ["fish"],
  0x7E1 => ["subway"],
  0x346 => ["bearing"],
  0x511 => ["birthday"],
  0x823 => ["kissmark"],
  0x4D0 => ["denim"],
  0xAF4 => ["up"],
  0x553 => ["foot"],
  0xB77 => ["shine"],
  0x035 => ["aquarius"],
  0x1BE => ["horse"],
  0x7E2 => ["bullettrain"],
  0x347 => ["wink"],
  0x512 => ["xmas"],
  0xB36 => ["new"],
  0x824 => ["loveletter"],
  0x4D1 => ["crown"],
  0xAF5 => ["down"],
  0x036 => ["pisces"],
  0x1BF => ["pig"],
  0x7E3 => ["bullettrain"],
  0x348 => ["happy01"],
  0x825 => ["ring"],
  0x4D2 => ["crown"],
  0xAF6 => ["leftright"],
  0x7E4 => ["car"],
  0x349 => ["smile"],
  0x826 => ["ring"],
  0x34A => ["happy02"],
  0xAF7 => ["updown"],
  0x038 => ["wave"],
  0x7E5 => ["rvcar"],
  0x827 => ["kissmark"],
  0x34B => ["lovely"],
  0x7E6 => ["bus"],
  0x34C => ["lovely"],
  0x829 => ["heart02"],
  0x34D => ["weep"],
  0x7E8 => ["ship"],
  0x4D6 => ["boutique"],
  0x03B => ["night"],
  0x4D7 => ["boutique"],
  0x34E => ["pout"],
  0x7E9 => ["airplane"],
  0x03C => ["clover"],
  0x82B => ["freedial"],
  0x973 => ["typhoon"],
  0x34F => ["smile"],
  0x7EA => ["yacht"],
  0x03D => ["tulip"],
  0x82C => ["sharp"],
  0x350 => ["sad"],
  0x7EB => ["bicycle"],
  0x03E => ["bud"],
  0x82D => ["mobaq"],
  0x351 => ["ng"],
  0x1C8 => ["chick"],
  0xB81 => ["id"],
  0x03F => ["maple"],
  0xE10 => ["info01"],
  0x82E => ["one"],
  0x4DB => ["t-shirt"],
  0x352 => ["ok"],
  0x1C9 => ["fish"],
  0xB82 => ["key"],
  0x040 => ["cherryblossom"],
  0xE11 => ["info02"],
  0x82F => ["two"],
          }

        end
      end
    end
  end
end

