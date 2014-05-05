require 'xcodeproj'

module May
  class Xcodeproj
    def initialize(path)
      @project = ::Xcodeproj::Project.open(path)
    end

    def add_file(real_path, group_path = nil)
      group_path = retrive_relative_path(real_path) unless group_path
      group = visit_group(group_path)
      group.new_file(real_path)
    end

    def retrive_relative_path(abs_real_path)
      File.dirname(abs_real_path).sub(File.dirname(@project.path.to_s), '')
    end

    def save
      @project.save
    end

    def exists?(real_path)
      group_path = retrive_relative_path(real_path)
      group = visit_group(group_path)
      group.files.map(&:path).include?(File.basename(real_path))
    end

    private
    def visit_group(group_path)
      group_nodes = group_path.split('/').select{ |x| !x.empty? }
      node = @project.main_group
      begin
        group_nodes.each do |destinaton|
          node = node.groups.select{ |group| group.path == destinaton }.first
        end
      rescue
        warn "Can't find group(#{group_path})."
        return nil
      end
      node
    end
  end
end
