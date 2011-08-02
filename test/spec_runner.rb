require 'test/unit'

class SpecRunner < Test::Unit::TestCase
  
  def load_spec
    begin
      require 'spec'
    rescue LoadError
      if require "rubygems"
        gem 'rspec', '<2.0.0'
        retry
      end
      puts "All tests are skipped.(Please `gem install rspec`)"
      return
    end
  end

  def test_spec
    return unless load_spec
    require File.expand_path(File.join(File.dirname(__FILE__), '../spec/spec_helper.rb'))

    argv = Dir.glob(File.expand_path File.join(File.dirname(__FILE__), '../spec/**/*_spec.rb'))
    argv.unshift '-fs'

    unless Spec::Runner::CommandLine.run(Spec::Runner::OptionParser.parse(argv, STDOUT, STDERR))
      fail "failure(s)."
    end
  end

end
