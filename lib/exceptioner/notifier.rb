module Exceptioner
  class Notifier

    def self.dispatch(exception, options = {})
      if dispatch_exception?(exception)
        options = determine_options(exception, options.dup)
        determine_transports(options) do |transport|
          transport.deliver(options)
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
      available_transports = classify_transports(options[:transports] || transports)
      available_transports.each { |transport| yield transport }
      available_transports
    end

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

    def self.config
      Exceptioner
    end

    def self.dispatch_exception?(exception)
      ! (config.development_environments.include?(config.environment_name) || ignore_exception?(exception))
    end

    def self.ignore_exception?(exception)
      if config.ignore
        # TODO: stringify config.ignore once
        Array(config.ignore).collect(&:to_s).include?(exception_class_name(exception))
      end
    end

    # Determines class of exception.
    def self.exception_class_name(exception)
      exception.is_a?(Exception) ? exception.class.name : exception.to_s
    end

  end
end
