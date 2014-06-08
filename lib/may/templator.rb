require 'tilt/erb'

module May
  class Templator
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

    class Generator
      def initialize(bind)
        @binding = bind
      end

      def generate(template)
        Tilt::ERBTemplate.new(template.path, { trim: '<>' }).render(@binding)
      end
    end

    def initialize(template_path, destination, bind)
      @template_path, @destination, @binding = template_path, destination, bind
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
