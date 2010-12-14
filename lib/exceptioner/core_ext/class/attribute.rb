# This code is stolen from ActiveSupport gem. 
# We don't need to instance accessors so they're removed
# for cattr_ methods so responsible part of code was removed.
#
# Note we don't overwrite class_attribute method if it exists already.
class Class
  unless method_defined?(:class_attribute)
    require 'exceptioner/core_ext/kernel/singleton_class'
    require 'exceptioner/core_ext/module/remove_method'

    def class_attribute(*attrs)
      attrs.each do |name|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{name}() nil end
          def self.#{name}?() !!#{name} end

          def self.#{name}=(val)
            singleton_class.class_eval do
              remove_possible_method(:#{name})
              define_method(:#{name}) { val }
            end
            val
          end
        RUBY

      end
    end
  end
end
