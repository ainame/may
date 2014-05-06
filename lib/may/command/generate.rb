require 'may/templator'
require 'may/path_resolver'
require 'may/xcodeproj'

module May
  class Command
    class Generate
      def self.run(context, *args)
        new(context).run(*args)
      end

      def initialize(context)
        @context = context
      end

      def run(*args)
        Dir.chdir(@context.root_dir) do
          run_wtihout_context(*args)
        end
      end

      def run_wtihout_context(*args)
        parse_args(args)

        xcodeproj = May::Xcodeproj.new(@context.xcodeproj_path)
        resolver.each(@path, @template_name) do |template_path, destination|
          puts "use emplate: #{template_path}"
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

      def write_generate_file(template_path, destination)
        binding = May::RenderBinding.new(class_name: @class_name)
        May::Templator.new(template_path, destination, binding).write
      end
    end
  end
end
