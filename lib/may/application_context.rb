module May
  class ApplicationContext
    def current_dir
      Dir.pwd
    end

    def root_dir(path = current_dir)
      raise "Can't find a xcodeproj file" if path == '/'
      Dir.entries(path).select{ |d| d =~ /.*\.xcodeproj/ }.empty? ? root_dir(File.dirname(path)) : path
    end

    def template_dir
      File.expand_path(File.join(File.dirname(__FILE__),'../../templates'))
    end

    def xcodeproj_path
      Dir[File.join(root_dir, '*.xcodeproj')].first
    end
  end
end
