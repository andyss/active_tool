require "active_tool/associate/proxy"
require "active_tool/associate/mongo_proxy"

module ActiveTool
  module Associate
    extend ActiveSupport::Concern
    
    included do
      use_proxy ActiveTool::Associate::Proxy
    end
    
    def assocaite_keys
      self.class.assocaite_keys
    end
    
    module ClassMethods
      def assocaite_keys
        @assocaite_keys ||= []
      end

      def assocaite_keys=(attrs)
        @assocaite_keys = attrs
      end
      
      def use_proxy(_proxy)
        self.class_eval <<-STR
          def self.proxy
            #{_proxy.to_s}
          end        
        STR
      end
      
      def many_associate(name, options = {})      
        define_method(name) do
          klass = name.to_s.singularize.classify.constantize
          klass.proxy.new(klass, self)
        end
      end

      def one_associate(name, options = {})
        define_method(name) do
          klass = name.to_s.singularize.classify.constantize
          klass.proxy.new(klass, self, true).real
        end
      end

      def associate(name, options = {})
        assocaite_keys << "#{name.to_s.singularize}_id".to_sym
        attr_accessor name        
      end            
    end
  end  
end