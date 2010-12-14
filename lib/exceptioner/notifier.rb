module Exceptioner
  class Notifier

    def self.dispatch(exception, options = {})
      if exception.is_a?(Hash)
        options = exception
        exception = nil
      else
        options[:exception]       ||= exception
        options[:exception_class] ||= exception.class
        options[:error_message]   ||= exception.message
        options[:backtrace]       ||= exception.backtrace
      end
      available_transports = classify_transports(options[:transports] || transports)
      available_transports.each do |transport|
        transport.deliver(options)
      end
    end

    protected
    def self.transports
      Exceptioner.transports
    end

    def self.classify_transports(transports)
      transports.collect do |transport|
        begin
          transport.is_a?(Class) ? transport : Transport.const_get(transport.to_s.camelize)
        rescue NameError
          raise ExceptionerError, "No such transport: #{transport.to_s}"
        end
      end
    end

  end
end
