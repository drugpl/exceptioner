module Exceptioner
  class Notifier

    cattr_writer :transports

    def self.dispatch(exception, options = {})
      available_transports = classify_transports(options[:transports] || transports)
      available_transports.each do |transport|
        transport.deliver(exception, options)
      end
    end

    protected
    def self.transports
      Exceptioner.transports
    end

    def self.classify_transports(transports)
      transports.collect do |transport|
        begin
          transport.is_a?(Class) ? transport : Transport.const_get(transport)
        rescue NameError
          raise ExceptionerError, "No such transport: #{transport.to_s}"
        end
      end
    end

  end
end
