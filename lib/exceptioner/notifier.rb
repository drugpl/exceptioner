module Exceptioner
  class Notifier
    def self.dispatch(options = {})
      issue = Issue.new(options)

      if Exceptioner.run_dispatchers(issue.exception)
        determine_transports(issue.transports) do |transport|
          if transport.run_dispatchers(issue.exception)
            transport.deliver(issue)
          end
        end
      end
    end

    protected

    def self.determine_transports(issue_transports)
      (issue_transports || transports).each do |transport|
        yield transport_instance(transport)
      end
    end

    def self.transports
      config.transports
    end

    def self.config
      Exceptioner.config
    end

    # Determines class of exception.
    def self.exception_class_name(exception)
      exception.is_a?(Exception) ? exception.class.name : exception.to_s
    end

    def self.transport_instance(transport)
      Exceptioner.transport_instance(transport)
    end
  end
end
