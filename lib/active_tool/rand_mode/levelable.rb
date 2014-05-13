require "securerandom"

module ActiveTool
  module RandMode
    module Levelable
      extend ActiveSupport::Concern
    
      def self.included(base)
        base.extend(ClassMethods)
      end
    
      module ClassMethods      
        def levelable(obj_name, options={})
          define_method("#{obj_name}_level") do
            objs = self.send(obj_name)
            level = 0
            max_rd = objs.map(&:prob).inject(:+).to_i
            rd = SecureRandom.random_number(max_rd)
            # rd = rd % max_rd 
            objs.each_with_index do |obj, i|
              if rd < obj.prob
                level = i
                break
              end
              rd -= obj.prob
            end
          
            objs[level].name
          end
        end
      end
    end
  end
end