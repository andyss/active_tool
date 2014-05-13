module ActiveTool
  module FakeModel  
    extend ActiveSupport::Concern

    included do
      attr_accessor :attrs
    end

    def initialize(attrs = {})
      @attrs = {}
      attrs.keys.map do |key|
        @attrs[key.to_sym] = attrs[key]
      end
      after_initialize
    end
    
    def after_initialize; end

    def write_fake_attribute(attr_name, value)
      @attrs[attr_name] = value
    end

    def read_fake_attribute(attr_name)
      @attrs[attr_name]
    end
    
    def after_write(attr_name)
    end
    
    def attribute_names
      self.class.attribute_names
    end

    module ClassMethods
      def attribute_names
        @attribute_names ||= []
      end

      def attribute_names=(attrs)
        @attribute_names = attrs
      end

      def define_read_attribute(name)
        self.module_eval <<-STR, __FILE__, __LINE__ + 1      
          def #{name}
            read_fake_attribute("#{name}".to_sym)
          end
        STR
      end

      def define_write_attribute(name)
        self.module_eval <<-STR, __FILE__, __LINE__ + 1
          def #{name}=(value)
            write_fake_attribute("#{name}".to_sym, value)
            after_write("#{name}".to_sym)
            value
          end
        STR
      end

      def define_attrs(*args)
        self.attribute_names ||= []
        self.attribute_names += args

        args.map do |_attr|
          define_write_attribute(_attr)
          define_read_attribute(_attr)
        end
      end
    end
  end
end