require 'tilt/erb'

module May
  class Template
    def initialize(path)
      @file = File.open(path, 'r')
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
      @hash[:class_name]
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

  class Templator
    def initialize(class_name, template_path, destination)
      @class_name, @template_path, @destination = class_name, template_path, destination
    end

    def render
      context = RenderContext.new(class_name: @class_name)
      template = Template.new(@template_path)
      Generator.new(context).generate(template)
    end

    def write
      File.open(@destination, 'w') do |f|
        f.puts render
      end
    end
  end
end
