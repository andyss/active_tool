module ActiveTool
  module Associate
    class MongoProxy < Proxy
      def initialize(klass, associate, type=false)
        @klass =  klass
        @associate = associate
        
        if type
          self.extend(MongoProxyOne)          
        else
          self.extend(MongoProxyMany)
        end
      end      
      
      def associate?
        self.respond_to?(:associate_id)
      end
      
      def associate_condition
        {self.associate_id_name.to_s => self.associate_id}
      end
      
      module MongoProxyOne
        def real
          self.new(coll.find_one(associate_condition))
        end
        
        def inspect
          self.new(coll.find_one(associate_condition))
        end
      end
      
      module MongoProxyMany
        def map(&block)
          self.all.map(&block)
        end

        def each(&block)
          self.all.each(&block)
        end

        def each_with_index(&block)
          self.all.each_with_index(&block)
        end

        def all
          conditions = {}
          if associate?
            conditions = associate_condition
          end

          docs = []
          coll.find(conditions).each do |doc|
            docs << self.new(doc)
          end

          docs
        end

        def where(attrs = {})
          conditions = {}
          if associate?
            conditions = associate_condition
          end

          conditions.merge!(attrs)

          docs = []
          coll.find(conditions).each do |doc|
            docs << self.new(doc)
          end

          docs
        end

        def delete_all
          if associate?
            coll.find(associate_condition).each do |doc|
              coll.remove(doc)
            end
          end        
        end


        def count
          coll.find(associate_condition).count
        end

        def first
          if associate?
            return self.new(coll.find_one(associate_condition))
          end
          nil
        end

        def inspect
          all
        end
      end
    end
  end
end