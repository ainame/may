module May
  class CustomCommand
    class TemplateCommand
      attr_accessor :command_name, :template_name, :description, :default_super_class
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
      def template_name(template_name)
        @command.template_name = template_name
      end

      def description(description)
        @command.description = description
      end

      def default_super_class(default_super_class)
        @command.default_super_class = default_super_class
      end
    end

    class Container
      @commands = Array.new
      
      class << self
        attr_reader :commands

        def store(command)
          @commands << command
        end

        def clear
          @commands = Array.new
        end
      end
    end
  end
end
