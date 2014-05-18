module May
  class RenderBinding
    def initialize(hash)
      @hash = hash
    end

    def class_name
      @hash[:class_name]
    end

    def options
      @hash[:options]
    end
  end
end
