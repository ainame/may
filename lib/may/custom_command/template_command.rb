module May
  class CustomCommand
    class TemplateCommand
      attr_accessor :command_name, :template_name,
        :description, :default_super_class, :arguments
    end

    class Builder
      def initialize(command_name)
        @command = TemplateCommand.new
        @command.command_name = command_name
      end

      def build(&block)
        raise unless block_given?
        instance_eval(&block)
        @command
      end

      private
      def template(template_name)
        @command.template_name = template_name
      end

      def description(description)
        @command.description = description
      end

      def super_class(default_super_class)
        @command.default_super_class = default_super_class
      end

      def arguments(arguments)
        @command.arguments = arguments
      end
    end
  end
end
