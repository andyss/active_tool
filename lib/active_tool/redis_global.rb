module ActiveTool
  module RedisGlobal
    
    class << self
      def get_int(name)
        get(name).to_i
      end
      
      def get(name)
        key = "g2server:#{name}"
        $redis.get(key)
      end
      
      def set(name, value)
        key = "g2server:#{name}"
        $redis.set(key, value)
      end
    end
  end
end