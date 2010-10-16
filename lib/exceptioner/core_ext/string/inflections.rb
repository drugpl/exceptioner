# This code is stolen from ActiveSupport gem. 

class String

    def camelize
      gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end unless method_defined?(:camelize)

end
