require 'may/custom_command/container'

module May
  class CustomCommand
    class Definer
      def initialize(super_class)
        @super_class = super_class
      end

      def define
        May::CustomCommand::Container.commands.each do |comand|
          define_commad(command)
        end
      end

      def define_commad
        raise 'override me'
      end

      class Generate < Definer
        CLASS_NAME_PREFIX = 'May::Command::Generate'

        def define_commad(command)
          klass = Class.new(@super_class) do
            self.command = command.command_name
            self.description = command.description
            self.template_name = command.template_name
            self.default_super_class = command.default_super_class
          end
          klass_name = CLASS_NAME_PREFIX + command.command_name.capitalize

          Object.const_set(klass_name, klass)
          Object.const_get(klass_name)
        end
      end
    end
  end
end
