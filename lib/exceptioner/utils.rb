module Exceptioner
  module Utils
    extend self

    def classify_transports(transports)
      transports.collect { |transport| classify_transport(transport) }
    end

    def classify_transport(transport)
      begin
        transport.is_a?(Class) ? transport : ::Exceptioner::Transport.const_get(transport.to_s.camelize)
      rescue NameError
        raise Exceptioner::ExceptionerError, "No such transport: #{transport.to_s}"
      end
    end
  end
end
