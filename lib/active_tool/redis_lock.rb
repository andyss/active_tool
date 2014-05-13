module ActiveTool
  module RedisLock
    LOCK_TIMEOUT = 1
  
    class << self
      def lock!(name)
        key = "lock.#{name}"
      
        while(true) do
          now = Time.now
          timestamp = now.to_i + LOCK_TIMEOUT
          locked = $redis.setnx(key, timestamp)
          last_timestamp = $redis.get(key).to_i
          if locked or (now.to_i > last_timestamp and now.to_i > $redis.getset(key, timestamp).to_i)
            break
          else
            sleep(0.2)
          end
        end
        
        yield
      
        if Time.now.to_i < $redis.get(key).to_i
          $redis.del(key)
        end
      end    
    end
  end
end