module Exceptioner
  class Notifier
    include Dispatchable

    def initialize(config)
      @config = config
      @transports = {}
      add_default_dispatchers
    end

    def dispatch(options = {})
      issue = Issue.new(default_options.merge options)

      if run_dispatchers(issue.exception)
        determine_transports(issue.transports) do |transport|
          config.logger.debug("Trying to dispatch an issue for #{transport.name}")
          if transport.run_dispatchers(issue.exception)
            config.logger.debug("Passing issue to #{transport.name}")
            transport.deliver(issue)
          end
        end
      end
    end

    def transport(name)
      @transports[name] ||= classify_transport(name).new(config.for(name))
    end

    def config
      @config
    end

    def add_default_dispatchers
      disallow_development_environment
      disallow_ignored_exceptions
    end

    protected

    def default_options
      { :application_path => config.application_path, :gem_path => config.gem_path }
    end

    def determine_transports(issue_transports)
      (issue_transports || transports).each do |transport_name|
        yield transport(transport_name)
      end
    end

    def transports
      config.transports
    end

    def classify_transport(transport_name)
      begin
        ::Exceptioner::Transport.const_get(Utils.camelize(transport_name.to_s))
      rescue NameError
        raise Exceptioner::ExceptionerError, "No such transport: #{transport_name.to_s}"
      end
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
