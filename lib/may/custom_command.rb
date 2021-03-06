module May
  class CustomCommand
    require 'may/custom_command/container'
    require 'may/custom_command/dsl'
    require 'may/custom_command/definer'

    attr_accessor :content

    def initialize(context)
      @context = context
    end

    def load
      @content = File.open(@context.custom_file).read
    end

    def eval_custom_file
      eval @content, DSL.get_binding
    end
  end
end
