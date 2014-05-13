require "active_tool/rand_mode/randable"

module ActiveTool
  module RandMode
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def add_mode(name, objs=[])
        define_method("rand_mode_#{name}") do
          items = objs.dup
          if items.size == 0
            items = self.send("#{name}_objs") if self.respond_to?("#{name}_objs")
          end

          if items.size > 0
            rd = Randable.new
            rd.add_items(items)
            rd.item
          else
            nil
          end
        end
      end
    end
  end
end