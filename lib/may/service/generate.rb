require 'may/templator'
require 'may/render_binding'
require 'may/path_resolver'
require 'may/xcodeproj'

module May
  module Service
    class Generate
      class InvalidArgumentError< StandardError; end

      def self.run(context, arguments = {})
        new(context).run_with_root_dir(arguments)
      end

      def initialize(context)
        @context = context
      end

      def run_with_root_dir(arguments)
        parse_args(arguments)
        Dir.chdir(@context.root_dir) do
          validate!
          run
        end
      end

      private
      def parse_args(arguments)
        raise "Can't find path" unless arguments.size > 0
        @path          = arguments[:path]
        @options       = arguments[:options]
        @class_name    = File.basename(@path) if @path
        @template_name = @options[:super_class] || 'NSObject' if @options
      end

      def validate!
        raise InvalidArgumentError unless File.exist?(File.dirname(@path))
      end

      def run
        resolver.tap do |r|
          add_file(r.template.header_file, r.source_project.header_file)
          add_file(r.template.implementation_file, r.source_project.implementation_file)
          add_file(r.template.test_file, r.test_project.test_file)
        end
        xcodeproj.save
      end

      def add_file(template_path, destination)
        puts "use template: #{template_path}"
        puts "write: #{destination}"

        write_generating_file(template_path, destination)
        xcodeproj.add_file(destination)

        puts ''
      end

      def resolver
        @resolver ||= May::PathResolver.new(@context, @path, @template_name)
      end

      def xcodeproj
        @xcodeproj ||= May::Xcodeproj.new(@context.xcodeproj_path)
      end

      def write_generating_file(template_path, destination)
        bind = May::RenderBinding.new(bind_values)
        May::Templator.new(template_path, destination, bind).write
      end

      def bind_values
        {
          class_name: @class_name,
          options: @options,
          organization_name: xcodeproj.organization_name,
          project_name: xcodeproj.build_targets[0].name,
          author_name: `git config --global --get user.name`.chomp,
        }
      end
    end
  end
end
