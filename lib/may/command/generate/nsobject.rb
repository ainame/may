require 'may/service/generate'

module May
  class Command
    class Generate
      class NSObject < Generate
        USING_TEMPLATE_NAME = 'NSObject'

        self.command = 'nsobject'
        self.description = <<EOS
PATH is a file path which you want to generate file without extension name.
EOS
        self.arguments = [
          ['PATH', :required],
          ['SUPER_CLASS', :optional],
        ]


        def initialize(argv)
          super
          @path    = argv.shift_argument
          @super_class = argv.shift_argument
          @options = argv.options
        end

        def validate!
          super
          help! 'Can\'t find a PATH' unless @path
        end

        def run
          Service::Generate.run(
            ApplicationContext.new,
            {
              path: @path,
              options: @options,
              template_name: USING_TEMPLATE_NAME,
              super_class_name: (@super_class || 'NSObject'),
            }
          )
        end
      end
    end
  end
end
