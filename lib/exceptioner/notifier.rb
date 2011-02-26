module Exceptioner
  class Notifier

    def self.dispatch(exception, options = {})
      if config.run_dispatchers(exception)
        options = determine_options(exception, options.dup)
        determine_transports(options) do |transport|
          if transport.class.run_dispatchers(exception)
            transport.deliver(options)
          end
        end
      end
    end

    protected
    def self.determine_options(exception, options)
      if exception.is_a?(Hash)
        options = exception
        exception = nil
      else
        options[:exception]       ||= exception
        options[:exception_class] ||= exception.class
        options[:error_message]   ||= exception.message
        options[:backtrace]       ||= exception.backtrace
      end
      return options
    end

    def self.determine_transports(options)
      # TODO: classify once
      available_transports = Exceptioner::Utils.classify_transports(options[:transports] || transports)
      available_transports.each { |transport_class| yield transport_instance(transport_class) }
      available_transports
    end

    def self.transports
      Exceptioner.transports
    end

    def self.config
      Exceptioner
    end

    # Determines class of exception.
    def self.exception_class_name(exception)
      exception.is_a?(Exception) ? exception.class.name : exception.to_s
    end

    def self.transport_instance(transport_class)
      Exceptioner.transport_instance(transport_class)
    end
  end
end
