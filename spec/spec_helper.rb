require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'c2y'

require 'rspec/its'
require 'tempfile'

class CloudConfigFile
  class << self
    def create
      Tempfile.open("cloudconfigfile") do |f|
        f.puts(yield)
        f.path
      end
    end
  end
end
