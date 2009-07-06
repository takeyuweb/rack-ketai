require 'test/unit'

class SpecRunner < Test::Unit::TestCase
  
  def load_spec
    begin
      require 'spec'
    rescue LoadError
      retry if require "rubygems"
      puts "All tests are skipped."
      return
    end
  end

  def test_spec
     return unless load_spec
    require File.join(File.dirname(__FILE__),
                      '../spec/spec_helper.rb')

    argv = Dir.glob(File.join(File.dirname(__FILE__),
                              '../spec/**/*_spec.rb'))
    argv.unshift '-fs'

    unless Spec::Runner::CommandLine.run(Spec::Runner::OptionParser.parse(argv, STDOUT, STDERR))
      fail "failure(s)."
    end
  end

end
