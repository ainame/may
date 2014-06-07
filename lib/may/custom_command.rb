module May
  class CustomCommand
    require 'may/custom_command/dsl'

    attr_accessor :content

    def initialize(context)
      @context = context
    end

    def load
      @content = custom_file = File.open(@context.custom_file).read
    end

    def eval_custom_file
      eval @content, DSL.get_binding
    end
  end
end
