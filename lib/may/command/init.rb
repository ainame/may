require 'fileutils'

module May
  class Command
    class Init < Command
      self.command = 'init'
      self.description = <<EOS
init command setup templates files, then it add .templates dir to your project.
EOS
      def run
        context = ApplicationContext.new
        destination = File.join(context.root_dir, '.templates')
        return help! "Already exists #{destination}." if File.exist?(destination)
        FileUtils.cp_r(context.template_dir, destination)
        puts "add template files to #{destination}."
      end
    end
  end
end
