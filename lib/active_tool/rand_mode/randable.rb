require "active_tool/rand_mode/levelable"

module ActiveTool
  module RandMode
    class Randable
      extend ActiveSupport::Concern
      include Levelable
        
      attr_accessor :items
      attr_reader :item
      levelable :items
    
      def initialize(items=[])
        @items = []
      
        add_items(items)
      end
    
      def add_items(_items)
        _items.map do |item|
          if item.kind_of?(Hash)
            add_item(item, item[:prob])
          elsif item.respond_to?(:prob)
            add_item(item, item.prob)
          else
            add_item(item)
          end
        end      
      end
    
      class RandObj
        attr_reader :name
        attr_accessor :prob
      
        def initialize(name, prob)
          @name = name
          @prob = prob * 100 if prob
        end
      
        def prob?
          @prob
        end
      
        def inspect
          "#{@name}"
        end
      end
        
      def add_item(name, prob=nil)
        @items << RandObj.new(name, prob)
        self
      end
    
      def process_probs
        no_alloc_prob = (10000 - [10000, @items.map(&:prob).compact.inject(:+).to_i].min)
        no_prob = @items.size - @items.map(&:prob?).count(true)
            
        @items.map do |item|
          unless item.prob?
            item.prob = no_alloc_prob/no_prob
          end
        end
      end
    
      def item
        unless @item
          process_probs
          @item = self.items_level
        end
        @item
      end
    
      def reset
        @item = nil
      end
    end
  end
end