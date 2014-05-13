module ActiveTool
  module Associate
    class Proxy
      attr_accessor :klass, :associate

      def initialize(klass, associate, type=false)
        @klass =  klass
        @associate = associate        
      end      

      def associate_id_name
        "#{associate_name.to_s.singularize}_id".to_sym
      end
      
      def associate_id
        @associate.id.to_s
      end

      def associate_name
        @associate.class.to_s.downcase
      end

      def new(attrs={})
        attrs ||= {}
        @klass.new(attrs.merge({self.associate_id_name => self.associate_id}))
      end

      def create(attrs={})
        obj = self.new(attrs)
        obj.save
        obj
      end

      def method_missing(method, *args, &block)
        @klass.send(method, *args, &block)
      end

      def inspect
        "#<AssociateProxy []>"
      end
    end
  end
end