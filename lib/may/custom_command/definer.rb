require 'may/custom_command/container'

module May
  class CustomCommand
    class Definer
      def initialize(super_class)
        @super_class = super_class
      end

      def define
        May::CustomCommand::Container.commands.each do |command|
          define_commad(command)
        end
      end

      def define_commad
        raise 'override me'
      end

      class Generate < Definer
        def define_commad(command)
          klass = Class.new(@super_class) do
            self.command = command.command_name
            self.description = command.description
            self.template_name = command.template_name
            self.default_super_class = command.default_super_class
            self.arguments = [
              ['PATH', :required],
              ['SUPER_CLASS', :optional],
            ].concat(command.arguments || [])
          end
          klass_name = command.command_name.capitalize
          @super_class.const_set(klass_name, klass)
          @super_class.const_get(klass_name)
        end
      end
    end
  end
end
