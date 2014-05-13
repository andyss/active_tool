require 'active_support/concern'

module ActiveTool
  module MongoBase
    extend ActiveSupport::Concern
    include FakeModel
    include ActiveTool::Associate
    
    included do
      use_proxy ActiveTool::Associate::MongoProxy
      define_attrs :_id
    end
  
    def after_initialize
      try_find
      after_new
    end
    
    def after_new
    end
    
    def id
      @attrs[:_id]
    end
    
    def new?
      !id
    end
    
    def destroy
      unless self.new?
        x = coll.remove(@attrs) 
      end
    end
        
    def restore(doc)
      self.attribute_names.map do |_attr|
        @attrs[_attr.to_sym] = doc[_attr.to_s]
      end
    end
    
    def try_find
      doc = coll.find_one(primary_conditions)
      restore(doc) if doc
    end
  
    def db
      self.class.db
    end
  
    def coll
      self.class.coll
    end
    
    def primary_key?(k)
      self.primary_keys.index(k)
    end
  
    def primary_conditions?
      primary_conditions.values.compact.size == primary_keys.size
    end
    
    def after_write(attr_name)
      if primary_key?(attr_name) && primary_conditions?
        try_find
      end
    end
    
    def before_save
    end
    
    def after_save
    end

		def saveable?
			true
		end
  
    def save
			if saveable?
				before_save

	      if new?
	        coll.insert(@attrs)
	      else
	        coll.save(@attrs)
	      end

	      after_save
			end
    end
    
    def save!
      save
    end
  
    module ClassMethods     
      def db
        @db ||= $mongo.db("g2")
      end

      def coll
        @coll ||= db.collection(self.to_s.downcase.pluralize)
      end
                
      def set_primary_key(*keys)
        define_method(:primary_keys) do
          keys
        end
        
        define_method(:primary_conditions) do
          h = {}
          keys.map do |key|
            v = self.send(key)
            if !v.kind_of?(Fixnum) && !v.kind_of?(String) && !v.nil?
              v = v.to_s
            end
            h[key.to_s] = v
          end
          h
        end      
      end  
      
      
      def where(attrs = {})
        docs = []
        coll.find(attrs).each do |doc|
          docs << self.new(doc)
        end
        
        docs
      end  
      
      def all
        docs = []
        coll.find.each do |doc|
          docs << self.new(doc)
        end
        docs
      end  
    end
  end
end