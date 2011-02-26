require 'valueable'

module Exceptioner

  # TODO: transport-level configuration should be moved to separate gem
  class Configuration < Valuable

    class Base < Valuable

      has_value :sender, :klass => String

      has_collection :recipients

      has_value :prefix, :klass => String, :default => ""

      has_value :subject, :klass => String, :default => "[ERROR] "

    end

    class Authenticable < Base

      has_value :username, :klass => String

      has_value :password, :klass => String

    end

    class Mail < Base

      has_value :delivery_method, :klass => Symbol, :default => :sendmail

      has_value :delivery_options, :klass => Hash, :default => {}

    end

    class Irc < Base

      has_value :server, :klass => String

      has_value :port, :klass => Integer, :default => 6667

      has_value :nick, :klass => String, :default => 'exceptioner'

    end

    class Jabber < Authenticable

      has_value :jabber_id, :klass => String

    end

    class Redmine < Base

      has_value :project, :klass => String

      has_value :options, :klass => Hash

    end

    class Campfire < Authenticable

      has_value :subdomain, :klass => String

      has_value :token, :klass => String

    end

    class Transports < Valuable

      has_value :mail, :klass => Mail, :default => Mail.new

      has_value :irc, :klass => Irc, :default => Irc.new

      has_value :jabber, :klass => Jabber, :default => Jabber.new

      has_value :redmine, :klass => Redmine, :default => Redmine.new

      has_value :campfire, :klass => Campfire, :default => Campfire.new

    end

    has_value :transports, :klass => Transports, :default => Transports.new

  end

end
