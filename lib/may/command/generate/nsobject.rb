require 'may/service/generate'

module May
  class Command
    class Generate
      class NSObject < Generate
        self.command = 'nsobject'
        self.description = <<EOS
PATH is a file path which you want to generate file without extension name.
EOS
        self.arguments = [
          ['PATH', :required],
          ['SUPER_CLASS', :optional],
        ]

        self.template_name = 'NSObject'
        self.default_super_class = 'NSObject'
      end
    end
  end
end
