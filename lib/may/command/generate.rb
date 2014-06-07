require 'may/custom_command/definer'

module May
  class Command
    class Generate < Command
      require 'may/command/generate/nsobject'

      self.abstract_command = true
      self.command = 'generate'

      class << self
        attr_accessor :template_name, :default_super_class
      end

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
            template_name: class.template_name,
            super_class_name: (@super_class || class.default_super_class),
          }
        )
      end
    end
  end
end

May::CustomCommand::Definer::Generate.new(May::Command::Generate).define
