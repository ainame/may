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
        destination = context.root_dir
        return help! "Already exists #{context.custom_file}." if File.exists?(context.custom_file)
        FileUtils.cp(context.template_dir + '/Mayfile', destination)
        FileUtils.cp_r(context.template_dir + '/.templates', destination)
        puts "add template files to #{destination}."
      end
    end
  end
end
