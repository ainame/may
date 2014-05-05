require 'tilt/erb'

module May
  class Template
    def initialize(file)
      @file = file
    end

    def path
      @file.path
    end

    def body
      return '' unless @file
      @body ||= @file.read
    end
  end

  class RenderContext
    def initialize(hash)
      @hash = hash
    end

    def class_name
      @hash[:class]
    end
  end

  class Generator
    def self.generate(tempalte)
      new(RenderContext.new).generate(template)
    end

    def initialize(context)
      @context = context
    end

    def generate(template)
      Tilt::ERBTemplate.new(template.path, { trim: '<>' }).render(@context)
    end
  end
end
