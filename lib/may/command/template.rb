require 'fileutils'

module May
  class Command
    class Template < Command
      self.command = 'template'
      self.description = <<EOS
Add a base template file to .templates dir.
EOS

      self.arguments = [
        ['TEAMPLATE_NAME', :required]
      ]

      BASE_FILES = [{
          source: 'BASE_HEADER.erb',
          format: "%s.h.erb"
        }, {
          source: 'BASE_IMPL.erb',
          format: "%s.m.erb"
        }, {
          source: 'BASE_TEST.erb',
          format: "%sTests.m.erb"
        }
      ].freeze

      def initialize(argv)
        @template_name = argv.shift_argument
      end

      def validate!
        help! "Can't find a TEMPLATE_NAME." unless @template_name
      end

      def run
        context = ApplicationContext.new
        BASE_FILES.each do |source_and_format|
          source = File.join(context.template_dir, source_and_format[:source])
          new_name = sprintf(source_and_format[:format],  @template_name)
          destination = File.join(context.project_template_dir, new_name)
          FileUtils.copy(source, destination)
        end
      end
    end
  end
end
