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

  class ProjectTemplateResolver < FileResolver
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
    def initialize(context)
      @context = context
    end

    def each(path, template_name)
      raise unless block_given?
      relative_path = except_project_path(path)
      yield project_or_base_template_resolver(template_name).header_file(template_name), source_project.header_file(relative_path)
      yield project_or_base_template_resolver(template_name).implementation_file(template_name), source_project.implementation_file(relative_path)
      yield project_or_base_template_resolver(template_name).test_file(template_name), test_project.test_file(relative_path)
    end

    def project_or_base_template_resolver(template_name)
      File.exist?(project_template_resolver.header_file(template_name)) ? project_template_resolver : template_resolver
    end

    def except_project_path(path)
      path.split("/").select{ |str| str != '.' && str != '..' }[1..-1].join('/')
    end

    def template_resolver
      @template_resolver ||= TemplateResolver.new(@context.template_dir)
    end

    def project_template_resolver
      @project_template_resolver ||= ProjectTemplateResolver.new(@context.project_template_dir)
    end

    def project_resolver
      @project_resolver ||= ProjectResolver.new(@context.root_dir)
    end

    def source_project
      @source_project ||= DestinationResolver.new(project_resolver.source_project)
    end

    def test_project
      @test_project ||= DestinationResolver.new(project_resolver.test_project)
    end
  end
end
