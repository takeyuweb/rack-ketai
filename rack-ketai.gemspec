# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-ketai}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yuichi Takeuchi"]
  s.date = %q{2012-12-10}
  s.email = %q{info@takeyu-web.com}
  s.files = Dir["{lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.homepage = %q{http://github.com/take-yu/rack-ketai}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A Rack Middleware for Japanese mobile-phones}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
    else
      s.add_dependency(%q<rack>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.0.0"])
  end
  s.add_development_dependency "rspec"
end
