module ActiveTool
  module RedisCache
    extend ActiveSupport::Concern
    
    included do
      before_save :update_redis_cache
    end
    
    def update_redis_cache
      
    end

    module ClassMethods
      def redis_cached(*names)
        names.map do |name|
          alias_method "#{name}_original", name
          
          define_method(name) do
            p "cached #{name}"
          end
        end
      end
    end
  end
end