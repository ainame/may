require 'bundler/setup'
require 'rspec'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  #config.order = 'random'

  config.before(:suite) do
  end
end

class Fixtures
  class << self
    def dir
      'spec/fixtures'
    end

    def file(filename)
      File.open(File.join(dir, filename))
    end
  end
end
