# This code is stolen from ActiveSupport gem. 
# We don't need to pass options like :instance_writer
# for mattr_ methods so responsible part of code was removed.
#
# Note we don't overwrite mattr_ methods if they exist already.

class Module
  def mattr_reader(*syms)
    syms.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        @@#{sym} = nil unless defined? @@#{sym}

        def self.#{sym}
          @@#{sym}
        end
      EOS
    end
  end unless method_defined?(:mattr_reader)

  def mattr_writer(*syms)
    syms.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def self.#{sym}=(obj)
          @@#{sym} = obj
        end
      EOS
    end 
  end unless method_defined?(:mattr_writer)

  def mattr_accessor(*syms)
    mattr_reader(*syms)
    mattr_writer(*syms)
  end unless method_defined?(:mattr_accessor)
end
