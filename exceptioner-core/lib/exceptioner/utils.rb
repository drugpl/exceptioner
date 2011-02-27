module Exceptioner
  module Utils
    extend self

    def camelize(string)
      string.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end
  end
end
