module May
  class ProjectResolver
    def initialize(root_dir)
      @root_dir = root_dir
    end

    def source_project(project_name = File.basename(@root_dir))
      join(project_name)
    end

    def test_project(project_name = File.basename(@root_dir))
      join(project_name + 'Tests')
    end

    private
    def join(project_name)
      File.join(@root_dir, project_name)
    end
  end

  class FileResolver
    def initialize(base_dir)
      @base_dir = base_dir
    end

    def header_file(path)
      join(path + '.h')
    end

    def implementation_file(path)
      join(path + '.m')
    end

    def test_file(path)
      join(path + 'Test.m')
    end
  end

  class TemplateResolver < FileResolver
    EXTENTION_NAME = '.erb'
    private
    def join(path)
      template_filename = path + EXTENTION_NAME
      File.join(@base_dir, template_filename)
    end
  end

  class DestinationResolver < FileResolver
    private
    def join(filename)
      File.join(@base_dir, filename)
    end
  end

  class PathResolver
    def initialize(context)
      @context = context
      @project_resolver = ProjectResolver.new(@context.root_dir)
      @template_resolver = TemplateResolver.new(@context.template_dir)
    end

    def each(path, template_name)
      raise unless block_given?
      yield template(:header, template_name), destination(:header, path)
      yield template(:implementation, template_name), destination(:implementation, path)
      yield template(:test, template_name), destination(:test, path)
    end

    def template(type, template_name)
      case type
      when :header
        @template_resolver.header_file(template_name)
      when :implementation
        @template_resolver.implementation_file(template_name)
      when :test
        @template_resolver.test_file(template_name)
      end
    end

    def destination(type, path)
      case type
      when :header
        source_project.header_file(path)
      when :implementation
        source_project.implementation_file(path)
      when :test
        test_project.test_file(path)
      end
    end

    def source_project
      @source_project ||= DestinationResolver.new(@project_resolver.source_project)
    end

    def test_project
      @test_project ||= DestinationResolver.new(@project_resolver.test_project)
    end
  end
end
