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
        @path             = arguments[:path]
        @options          = arguments[:options]
        @super_class_name = arguments[:super_class_name]
        @template_name    = arguments[:template_name]
        @properties       = arguments[:properties]
        @class_name       = File.basename(@path) if @path
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
      end

      def add_file(template_path, destination)
        puts "use template: #{template_path}".ansi.bold
        unless File.exists?(template_path)
          warn "warning: Can't find a #{template_path}. So, abort this file.".ansi.yellow
          return
        end
        puts "write: #{destination}".ansi.green

        templator = May::Templator.new(template_path, destination, bind_values)
        templator.write
        xcodeproj.add_file(destination)
        xcodeproj.save

        puts ''
      end

      def resolver
        @resolver ||= May::PathResolver.new(@context, @path, @template_name)
      end

      def xcodeproj
        @xcodeproj ||= May::Xcodeproj.new(@context.xcodeproj_path)
      end

      def bind_values
        May::RenderBinding.new(
          class_name: @class_name,
          super_class_name: @super_class_name,
          properties: @properties,
          options: @options,
          header: {
            organization_name: xcodeproj.organization_name,
            project_name: xcodeproj.build_targets[0].name,
            author_name: `git config --global --get user.name`.chomp,
          },
        )
      end
    end
  end
end
