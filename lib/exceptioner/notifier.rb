module Exceptioner
  class Notifier
    include Dispatchable

    def initialize(config)
      @config = config
      @transport_instances = {}
      add_default_dispatchers
    end

    def dispatch(options = {})
      issue = Issue.new(options)

      if run_dispatchers(issue.exception)
        determine_transports(issue.transports) do |transport|
          if transport.run_dispatchers(issue.exception)
            transport.deliver(issue)
          end
        end
      end
    end

    def transport_instance(transport)
      @transport_instances[transport] ||= Utils.classify_transport(transport).new
    end

    def config
      @config
    end

    def add_default_dispatchers
      disallow_development_environment
      disallow_ignored_exceptions
    end

    protected

    def determine_transports(issue_transports)
      (issue_transports || transports).each do |transport|
        yield transport_instance(transport)
      end
    end

    def transports
      config.transports
    end

    # Determines class of exception.
    def exception_class_name(exception)
      exception.is_a?(Exception) ? exception.class.name : exception.to_s
    end

    def disallow_development_environment
      add_dispatcher do |exception|
        ! config.development_environments.include?(config.environment_name)
      end
    end

    def disallow_ignored_exceptions
      add_dispatcher do |exception|
        ! Array(config.ignore).collect(&:to_s).include?(exception.class.name)
      end
    end
  end
end
