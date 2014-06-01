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
        ]

        def initialize(argv)
          super
          @path    = argv.shift_argument
          @options = argv.options
        end

        def validate!
          super
          help! 'Can\'t find a PATH' unless @path
        end

        def run
          Service::Generate.run(
            ApplicationContext.new,
            { path: @path, options: @options.merge({ super_class: 'NSObject' }) }
          )
        end
      end
    end
  end
end
