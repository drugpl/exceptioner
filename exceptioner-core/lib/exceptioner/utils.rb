module Exceptioner
  module Utils
    extend self

    def camelize(string)
      string.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end

    def classify_transports(transports)
      transports.collect { |transport| classify_transport(transport) }
    end

    def classify_transport(transport)
      begin
        transport.is_a?(Class) ? transport : ::Exceptioner::Transport.const_get(camelize(transport.to_s))
      rescue NameError
        raise Exceptioner::ExceptionerError, "No such transport: #{transport.to_s}"
      end
    end
  end
end
