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
          if transport.run_dispatchers(issue.exception)
            transport.deliver(issue)
          end
        end
      end
    end

    def transport(name)
      @transports[name] ||= begin
        transport = Utils.classify_transport(name).new
        transport.configure(config)
        transport
      end
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
