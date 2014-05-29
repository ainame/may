require 'may/templator'
require 'may/render_binding'
require 'may/path_resolver'
require 'may/xcodeproj'

module May
  class Command
    class Generate
      def self.run(context, *args)
        new(context).run_with_root_dir(*args)
      end

      def initialize(context)
        @context = context
      end

      def run_with_root_dir(*args)
        parse_args(args)
        Dir.chdir(@context.root_dir) do
          run
        end
      end

      def parse_args(args)
        raise "Can't find path" unless args.size > 0
        @path          = args.shift
        @class_name    = File.basename(@path)
        @options       = args.pop
        @template_name = options[:super_class] || 'NSObject'
      end

      def run
        resolver.each(@path, @template_name) do |template_path, destination|
          puts "use template: #{template_path}"
          puts "write: #{destination}"

          write_generate_file(template_path, destination)
          xcodeproj.add_file(destination)

          puts ''
        end

        xcodeproj.save
      end

      def resolver
        @resolver ||= May::PathResolver.new(@context)
      end

      def xcodeproj
        @xcodeproj ||= May::Xcodeproj.new(@context.xcodeproj_path)
      end

      def write_generate_file(template_path, destination)
        bind = May::RenderBinding.new(
          class_name: @class_name,
          organization_name: xcodeproj.organization_name,
          author_name: `git config --global --get user.name`.chomp,
          project_name: xcodeproj.build_targets[0].name,
          options: @options
        )
        May::Templator.new(template_path, destination, bind).write
      end
    end
  end
end
