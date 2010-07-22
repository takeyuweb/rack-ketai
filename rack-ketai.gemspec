# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-ketai}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yuichi Takeuchi"]
  s.date = %q{2010-07-22}
  s.email = %q{info@takeyu-web.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.rdoc",
     "VERSION",
     "lib/rack/ketai.rb",
     "lib/rack/ketai/carrier.rb",
     "lib/rack/ketai/carrier/abstract.rb",
     "lib/rack/ketai/carrier/au.rb",
     "lib/rack/ketai/carrier/cidrs/au.rb",
     "lib/rack/ketai/carrier/cidrs/docomo.rb",
     "lib/rack/ketai/carrier/cidrs/softbank.rb",
     "lib/rack/ketai/carrier/docomo.rb",
     "lib/rack/ketai/carrier/emoji/ausjisstrtoemojiid.rb",
     "lib/rack/ketai/carrier/emoji/docomosjisstrtoemojiid.rb",
     "lib/rack/ketai/carrier/emoji/emojidata.rb",
     "lib/rack/ketai/carrier/emoji/emojiidtotypecast.rb",
     "lib/rack/ketai/carrier/emoji/softbankutf8strtoemojiid.rb",
     "lib/rack/ketai/carrier/emoji/softbankwebcodetoutf8str.rb",
     "lib/rack/ketai/carrier/general.rb",
     "lib/rack/ketai/carrier/iphone.rb",
     "lib/rack/ketai/carrier/softbank.rb",
     "lib/rack/ketai/carrier/specs/au.rb",
     "lib/rack/ketai/carrier/specs/docomo.rb",
     "lib/rack/ketai/carrier/specs/softbank.rb",
     "lib/rack/ketai/display.rb",
     "lib/rack/ketai/middleware.rb",
     "spec/spec_helper.rb",
     "spec/unit/au_filter_spec.rb",
     "spec/unit/au_spec.rb",
     "spec/unit/carrier_spec.rb",
     "spec/unit/display_spec.rb",
     "spec/unit/docomo_filter_spec.rb",
     "spec/unit/docomo_spec.rb",
     "spec/unit/emoticon_filter_spec.rb",
     "spec/unit/filter_spec.rb",
     "spec/unit/iphone_spec.rb",
     "spec/unit/middleware_spec.rb",
     "spec/unit/softbank_filter_spec.rb",
     "spec/unit/softbank_spec.rb",
     "spec/unit/valid_addr_spec.rb",
     "test/spec_runner.rb",
     "tools/generate_emoji_dic.rb",
     "tools/update_speclist.rb"
  ]
  s.homepage = %q{http://github.com/take-yu/rack-ketai}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Rack Middleware for Japanese mobile-phones}
  s.test_files = [
    "spec/unit/au_spec.rb",
     "spec/unit/middleware_spec.rb",
     "spec/unit/filter_spec.rb",
     "spec/unit/au_filter_spec.rb",
     "spec/unit/softbank_filter_spec.rb",
     "spec/unit/valid_addr_spec.rb",
     "spec/unit/docomo_spec.rb",
     "spec/unit/display_spec.rb",
     "spec/unit/docomo_filter_spec.rb",
     "spec/unit/iphone_spec.rb",
     "spec/unit/softbank_spec.rb",
     "spec/unit/carrier_spec.rb",
     "spec/unit/emoticon_filter_spec.rb",
     "spec/spec_helper.rb",
     "test/spec_runner.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
    else
      s.add_dependency(%q<rack>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.0.0"])
  end
end

