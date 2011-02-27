require 'exceptioner/dispatchable'
require 'valuable'

module Exceptioner

  # TODO: transport-level configuration should be moved to separate gem
  class Configuration < Valuable
    include Exceptioner::Dispatchable

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

    has_value :application_path

    has_value :gem_path

    def only(*keys)
      Hash[self.attributes.select { |k,_| keys.include?(k) }]
    end

    class Authenticable < Configuration

      has_value :username, :klass => String

      has_value :password, :klass => String

    end

    class Mail < Configuration

      has_value :delivery_method, :klass => Symbol, :default => :sendmail

      has_value :delivery_options, :klass => Hash, :default => {}

    end

    has_value :mail, :klass => Mail, :default => Mail.new

    class Irc < Configuration

      has_value :server, :klass => String

      has_value :port, :klass => Integer, :default => 6667

      has_value :nick, :klass => String, :default => 'exceptioner'

      has_value :channel, :klass => String

    end

    has_value :irc, :klass => Irc, :default => Irc.new

    class Jabber < Authenticable

      has_collection :jabber_id

    end

    has_value :jabber, :klass => Jabber, :default => Jabber.new

    class Redmine < Configuration

      has_value :project, :klass => String

      has_value :options, :klass => Hash

    end

    has_value :redmine, :klass => Redmine, :default => Redmine.new

    class Campfire < Authenticable

      has_value :subdomain, :klass => String

      has_value :token, :klass => String

      has_value :rooms, :default => []

      has_value :room

      def room=(value)
        self.rooms = [value]
        self.room = value
      end

    end

    has_value :campfire, :klass => Campfire, :default => Campfire.new

    class Http < Configuration

      has_value :api_uri, :klass => String

      has_value :api_key, :klass => String

      has_value :api_version, :klass => String

    end

    has_value :http, :klass => Http, :default => Http.new

    # Define how to deliver exceptions data.
    # For example :mail, :jabber, :irc, :campfirenow
    has_value :transports, :default => [:mail]

  end

end
