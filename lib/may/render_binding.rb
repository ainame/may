module May
  class RenderBinding
    def initialize(hash)
      @hash = hash
    end

    def class_name
      @hash[:class_name]
    end

    def super_class_name
      @hash[:super_class_name]
    end

    def organization_name
      @hash[:organization_name]
    end

    def author_name
      @hash[:author_name]
    end

    def project_name
      @hash[:project_name]
    end

    def options
      @hash[:options]
    end
  end
end
