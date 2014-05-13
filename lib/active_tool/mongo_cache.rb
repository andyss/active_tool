module ActiveTool
  module MongoCache
    extend ActiveSupport::Concern
    
    included do
      before_create :create_cache
      before_update :update_cache
      before_destroy :remove_cache
    end
    
    def cached?
      true
    end
    
    def expired?
      true
    end
    
    def update_cache
      
    end
    
    def create_cache
    end
    
    def remove_cache
      
    end

    module ClassMethods
    end
    
  end
end