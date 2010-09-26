module Exceptioner
  class Notifier

    cattr_writer :transports

    def initialize(transports = default_transports, options = {})
      transports.each do |transport|
        unless transport.is_a?(Class)
          transport = Transports.const_get(transport)
        end
      end
    end

    def self.dispatch(exception, options = {})
      available_transports = classify_transports(options[:transports] || transports)
      available_transports.each do |transport|
        transport.deliver(exception, options)
      end
    end

    protected
    def self.default_transports
      [Transport::Email]
    end

    def self.transports
      @transports || default_transports
    end

    def self.classify_transports(transports)
      transports.collect do |transport|
        begin
          transport.is_a?(Class) ? transport : const_get(transport)
        rescue NameError
          raise ExceptionerError, "No such transport: #{transport.to_s}"
        end
      end
    end

  end
end
