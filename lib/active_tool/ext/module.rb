# class Module
#   
#   def delegate_with_value(*methods)
#     options = methods.pop
#     unless options.is_a?(Hash) && to = options[:to]
#       raise ArgumentError, 'Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, to: :greeter).'
#     end
# 
#     prefix, allow_nil = options.values_at(:prefix, :allow_nil)
# 
#     if prefix == true && to =~ /^[^a-z_]/
#       raise ArgumentError, 'Can only automatically set the delegation prefix when delegating to a method.'
#     end
# 
#     method_prefix =        if prefix
#         "#{prefix == true ? to : prefix}_"
#       else
#         ''
#       end
# 
#     file, line = caller.first.split(':', 2)
#     line = line.to_i
# 
#     to = to.to_s
#     to = 'self.class' if to == 'class'
# 
#     methods.each do |method|
#       # Attribute writer methods only accept one argument. Makes sure []=
#       # methods still accept two arguments.
#       definition = (method =~ /[^\]]=$/) ? 'arg' : '*args, &block'
# 
#       # The following generated methods call the target exactly once, storing
#       # the returned value in a dummy variable.
#       #
#       # Reason is twofold: On one hand doing less calls is in general better.
#       # On the other hand it could be that the target has side-effects,
#       # whereas conceptualy, from the user point of view, the delegator should
#       # be doing one call.
#       if allow_nil
#         module_eval(          def #{method_prefix}#{method}(#{definition})        # def customer_name(*args, &block)            _ = #{to}                                         #   _ = client            if !_.nil? || nil.respond_to?(:#{method})         #   if !_.nil? || nil.respond_to?(:name)              _.#{method}(#{definition})                      #     _.name(*args, &block)            end                                               #   end          end                                                 # end, file, line - 3)
#       else
#         exception = %(raise "#{self}##{method_prefix}#{method} delegated to #{to}.#{method}, but #{to} is nil: \#{self.inspect}")
# 
#         module_eval(          def #{method_prefix}#{method}(#{definition})                                          # def customer_name(*args, &block)            _ = #{to}                                                                           #   _ = client            _.#{method}(#{definition})                                                          #   _.name(*args, &block)          rescue NoMethodError => e                                                             # rescue NoMethodError => e            location = "%s:%d:in `%s'" % [__FILE__, __LINE__ - 2, '#{method_prefix}#{method}']  #   location = "%s:%d:in `%s'" % [__FILE__, __LINE__ - 2, 'customer_name']            if _.nil? && e.backtrace.first == location                                          #   if _.nil? && e.backtrace.first == location              #{exception}                                                                      #     # add helpful message to the exception            else                                                                                #   else              raise                                                                             #     raise            end                                                                                 #   end          end                                                                                   # end, file, line - 2)
#       end
#     end
#   end
# end