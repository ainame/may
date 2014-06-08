module May
  class RenderBinding
    class Property
      attr_accessor :variable, :type

      TYPE_MAP = {
        string: 'NSString *',
        number: 'NSNumber *',
      }.freeze

      def initialize(variable, type)
        @variable, @type = variable, type
      end

      def objc_type
        TYPE_MAP[type.to_sym] || 'id '
      end

      def objc_declaration
        "@property (nonatomic, strong) #{objc_type}#{variable};"
      end
    end

    def initialize(hash)
      @hash = hash
      prop_array = hash[:properties] || []
      @properties = prop_array.each_slice(2).map {|var, type| Property.new(var,type) }
    end

    def class_name
      @hash[:class_name]
    end

    def super_class_name
      @hash[:super_class_name]
    end

    def organization_name
      @hash[:header][:organization_name]
    end

    def author_name
      @hash[:header][:author_name]
    end

    def project_name
      @hash[:header][:project_name]
    end

    def options
      @hash[:options]
    end

    def properties
      @properties
    end
  end
end
