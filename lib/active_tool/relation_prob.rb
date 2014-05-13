module ActiveTool
  module RelationProb  
    class RelationModeProb
      attr_accessor :mode
      attr_accessor :probs
    
      def initialize(mode, &block)
        @mode = mode
        @probs = {}      
      
        self.instance_eval(&block)
      end
    
      def add_prob(name, options={})
        @probs[name] = options
      end
    end
  
    class RelationMode
      attr_accessor :name
      attr_accessor :relations
    
      def initialize(name, &block)
        @name = name
        @relations = {}
      
        self.instance_eval(&block)
      end
    
      def add_relation(mode, &block)
        @relations[mode] = RelationModeProb.new(mode, &block)
      end
    
      def has?(key)
        keys.index(key)
      end
    
      def keys
        self.relations.keys
      end
    end
  
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    def relation_modes
      self.class.relation_modes
    end
  
    def relation_mode_attrs
      self.class.relation_mode_attrs
    end
  
    def get_value(str)
      self.send(str)
    end
  
    def set_value(str, value)
      self.send("#{str}=", [[value, 0].max, 100].min)    
    end
  
    def incr_value(mode_attr, mode, relation, value)
      attr_str = "#{mode_attr}_prob_#{mode}_#{relation}"
      tmp_value = get_value(attr_str)
      set_value(attr_str, tmp_value + value)    
    end
  
    def change_value(mode_attr, mode, relation, value, incr=false)
      attr_str = "#{mode_attr}_prob_#{mode}_#{relation}"
      tmp_value = get_value(attr_str)
    
      if incr
        set_value(attr_str, tmp_value + value)
      else
        set_value(attr_str, tmp_value - value)      
      end
    end
    
    def decr_relation(mode, relation, type, mode_attr)
      # p "decr: #{relation_obj.probs[type][:decr]}"
      mode_obj = self.relation_modes[mode]
      relation_obj = mode_obj.relations[relation]    
      decr = relation_obj.probs[type][:decr]
      change_value(mode_attr, mode, relation, decr)
    end
  
    def decr_relations(mode, relations, type, mode_attr)
      relations.map do |relation|
        decr_relation(mode, relation, type, mode_attr)
      end
    end
  
    def incr_relation(mode, relation, type, mode_attr)
      mode_obj = self.relation_modes[mode]
      relation_obj = mode_obj.relations[relation]
      incr = relation_obj.probs[type][:incr]
      change_value(mode_attr, mode, relation, incr, true)
    end
  
    def incr_relations(mode, relations, type, mode_attr)
      relations.map do |relation|
        incr_relation(mode, relation, type, mode_attr)
      end
    end
  
    def set_relation_prob(mode, relation, type, mode_attr=nil)    
      mode_obj = self.relation_modes[mode]
      mode_attr = type unless mode_attr
    
      if mode_obj.has?(relation)
        decr_relation(mode, relation, type, mode_attr)
      end
    
      incr_relations(mode, mode_obj.keys - [relation], type, mode_attr)
      self
    end
    
    module ClassMethods
      def relation_modes
        @@relation_modes
      end
    
      def relation_mode_attrs
        @@relation_mode_attrs
      end
    
      def add_mode_attr(*attrs)
        @@relation_mode_attrs ||= []
        @@relation_mode_attrs += attrs
      end
    
      def add_relation_mode(mode, &block)
        @@relation_modes ||= {}
        @@relation_modes[mode] = RelationMode.new(mode, &block)
      end
    end
  end
end