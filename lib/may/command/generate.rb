require 'may/command'
require 'may/service/generate'

module May
  class Command
    class Generate < Command
      class << self
        attr_accessor :template_name, :default_super_class
      end

      require 'may/command/generate/nsobject'

      self.abstract_command = true
      self.command = 'generate'

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
            template_name: self.class.template_name,
           super_class_name: (@super_class || self.class.default_super_class || 'NSObject'),
          }
        )
      end
    end
  end
end
