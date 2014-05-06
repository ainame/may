require 'may/templator'
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
        Dir.chdir(@context.root_dir) do
          run(*args)
        end
      end

      def run(*args)
        parse_args(args)

        resolver.each(@path, @template_name) do |template_path, destination|
          puts "use template: #{template_path}"
          puts "write: #{destination}"

          write_generate_file(template_path, destination)
          xcodeproj.add_file(destination)

          puts ''
        end

        xcodeproj.save
      end

      def parse_args(args)
        h = args.shift
        raise "Can't parse options" unless h.kind_of?(Hash)
        @path = h[:path]
        @class_name = File.basename(h[:path])
        @template_name = h[:super_class_name] || 'NSObject'
      end

      def resolver
        @resolver ||= May::PathResolver.new(@context)
      end

      def xcodeproj
        @xcodeproj ||= May::Xcodeproj.new(@context.xcodeproj_path)
      end

      def write_generate_file(template_path, destination)
        bind = May::RenderBinding.new(class_name: @class_name)
        May::Templator.new(template_path, destination, bind).write
      end
    end
  end
end
