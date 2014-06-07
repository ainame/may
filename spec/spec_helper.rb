require 'bundler/setup'
require 'rspec'
require 'tmpdir'
require 'fileutils'

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
      File.expand_path(File.join(dir, filename))
    end

    def project
      file('FixtureProject')
    end
  end

  class Xcodeproj
    class << self
      def setup
        @tmp_dir = Dir.mktmpdir
        FileUtils.cp_r(::Fixtures.project, @tmp_dir)
      end

      def teardown
        FileUtils.remove_entry_secure @tmp_dir
      end

      def path
        File.join(@tmp_dir, 'FixtureProject/FixtureProject.xcodeproj')
      end

      def root_dir
        File.join(@tmp_dir, 'FixtureProject')
      end

      def classes_dir
        File.join(@tmp_dir, 'FixtureProject/FixtureProject/Classes')
      end

      def classes_file_for(filename)
        File.join(classes_dir, filename)
      end
    end
  end
end

class MockApplicationContext
  def current_dir
    Dir.pwd
  end

  def root_dir
    Fixtures::Xcodeproj.root_dir
  end

  def template_dir
    Fixtures.dir
  end

  def project_template_dir
    File.join(root_dir, '.templates')
  end

  def xcodeproj_path
    Fixtures::Xcodeproj.path
  end

  def custom_file
    File.join(project_template_dir, 'Mayfile')
  end
end
