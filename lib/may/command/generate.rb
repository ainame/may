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
      self.default_subcommand = 'nsobject'

      def self.options
        [
          ['--super_class', 'Specify super class']
        ].concat(super)
      end

      def initialize(argv)
        super
        @path = argv.shift_argument
        @options = argv.options
        @rest_args = argv.arguments!
        @super_class = argv.option('super_class')
      end

      def validate!
        super
        help! 'Can\'t find a PATH'.ansi.red unless @path && File.exists?(File.dirname(@path))
        help! 'Can\'t parse var and type'.ansi.red unless @rest_args.size % 2 == 0
      end

      def run
        Service::Generate.run(
          ApplicationContext.new,
          {
            path:             @path,
            options:          @options,
            properties:       @rest_args,
            template_name:    self.class.template_name,
            super_class_name: (@super_class || self.class.default_super_class || 'NSObject'),
          }
        )
      end
    end
  end
end
