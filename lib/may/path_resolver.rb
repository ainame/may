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
    def initialize(base_dir, path)
      @base_dir, @path = base_dir, path
    end

    def header_file
      join(@path + '.h')
    end

    def implementation_file
      join(@path + '.m')
    end

    def test_file
      join(@path + 'Tests.m')
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
    def join(path)
      File.join(@base_dir, path)
    end
  end

  class PathResolver
    def initialize(context, path, template_name)
      @context, @path, @template_name = context, path, template_name
      @relative_path = except_project_path(path)
    end

    def project
      @project_resolver ||= ProjectResolver.new(@context.root_dir)
    end

    def template
      @template_resolver ||= TemplateResolver.new(@context.project_template_dir, @template_name)
    end

    def source_project
      @source_project ||= DestinationResolver.new(project.source_project, @relative_path)
    end

    def test_project
      @test_project ||= DestinationResolver.new(project.test_project, @relative_path)
    end

    private
    def except_project_path(path)
      path.split("/").select{ |str| str != '.' && str != '..' }[1..-1].join('/')
    end
  end
end
