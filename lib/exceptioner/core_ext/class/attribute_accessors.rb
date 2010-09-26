# This code is stolen from ActiveSupport gem. 
# We don't need to pass options like :instance_writer
# for cattr_ methods so responsible part of code was removed.
#
# Note we don't overwrite cattr_ methods if they exist already.

class Class
  def cattr_reader(*syms)
    syms.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end
      EOS
    end
  end unless method_defined?(:cattr_reader)

  def cattr_writer(*syms)
    syms.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end
      EOS

      self.send("#{sym}=", yield) if block_given?
    end
  end unless method_defined?(:cattr_writer)

  def cattr_accessor(*syms, &blk)
    cattr_reader(*syms)
    cattr_writer(*syms, &blk)
  end unless method_defined?(:cattr_accessor)
end
