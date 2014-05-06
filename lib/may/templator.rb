require 'tilt/erb'

module May
  class Template
    def initialize(path)
      @file = File.open(path, 'r') if path
    end

    def path
      @file.path
    end

    def body
      return '' unless @file
      @body ||= @file.read
    end
  end

  class RenderBinding
    def initialize(hash)
      @hash = hash
    end

    def class_name
      @hash[:class_name]
    end
  end

  class Generator
    def initialize(binding)
      @binding = binding
    end

    def generate(template)
      Tilt::ERBTemplate.new(template.path, { trim: '<>' }).render(@binding)
    end
  end

  class Templator
    def initialize(template_path, destination, binding)
      @template_path, @destination, @binding = class_name, template_path, binding
    end

    def render
      template = Template.new(@template_path)
      Generator.new(@binding).generate(template)
    end

    def write
      File.open(@destination, 'w') do |f|
        f.puts render
      end
    end
  end
end
