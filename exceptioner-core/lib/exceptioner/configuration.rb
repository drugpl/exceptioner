require 'valuable'
require 'logger'

module Exceptioner

  # TODO: transport-level configuration should be moved to separate gem
  class Configuration < Valuable

    # Name of current environment.
    # For rails it would be development, test or production.
    # It's included in exception notification.
    # You can also combine it with development_environments to decide
    # when to handle exceptions by Exceptioner.
    has_value :environment_name, :klass => String

    # Define development environment. For these environments exceptions will not
    # be handled by Exceptioner.
    has_value :development_environments, :default => %w[development test cucumber]

    # Array of ignored exceptions.
    # By default it's set to exceptions defined in DEFAULT_IGNORED_EXCEPTIONS
    has_value :ignore, :default => %w[
      ActiveRecord::RecordNotFound
      ActionController::RoutingError
      ActionController::UnknownAction
    ]

    # If true exceptions raised by local requests will be delivered
    # Note it is Rails 2.x specific setting
    has_value :dispatch_local_requests, :klass => :boolean, :default => false

    has_value :enable, :klass => :boolean, :default => false

    has_value :sender, :klass => String, :default => 'exceptioner'

    has_collection :recipients

    has_value :prefix, :klass => String, :default => ""

    has_value :subject, :klass => String, :default => "[ERROR] "

    # Filesystem path to user's application and gems root.
    # These paths will be stripped from paths in backtraces.
    # Each of them can be array of paths.
    has_value :application_path
    has_value :gem_path

    # Logger
    has_value :logger

    has_value :template, :default => [:exception, :message, :backtrace, :params, :env]

    has_value :debug, :klass => :boolean, :default => false

    def only(*keys)
      Hash[self.attributes.select { |k,_| keys.include?(k) }]
    end

    # duplicates and merges with child config
    # TODO: valuable gem should expose merge method
    def for(name)
      if self.attributes.has_key?(name)
        local_config = send(name)
        local_config.class.new(self.only(*local_config.attributes.keys).merge(local_config.attributes))
      else
        self.dup
      end
    end

    class Authenticable < Configuration
      has_value :username, :klass => String
      has_value :password, :klass => String
    end

    # Define how to deliver exceptions data.
    # For example :mail, :jabber, :irc, :campfirenow
    has_value :transports, :default => [:mail]

  end

end
