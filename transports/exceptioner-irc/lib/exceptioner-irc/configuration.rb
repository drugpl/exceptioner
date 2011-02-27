require 'exceptioner/configuration'

module Exceptioner

  class Configuration

    class Irc < Configuration
      has_value :server, :klass => String
      has_value :port, :klass => Integer, :default => 6667
      has_value :nick, :klass => String, :default => 'exceptioner'
      has_value :channel, :klass => String
      has_value :provider, :default => :pastebin
    end
    has_value :irc, :klass => Irc, :default => Irc.new

  end

end
