require 'may/custom_command/template_command'

module May
  class CustomCommand
    class DSL
      class << self
        def get_binding
          binding
        end

        def register_command(command_name, &block)
          builder = Builder.new(command_name)
          command = builder.build(&block)
          Container.store(command)
          command
        end
      end
    end
  end
end
