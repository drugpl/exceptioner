require 'exceptioner/configuration'

module Exceptioner
  class Configuration

    class Jabber < Authenticable
      has_collection :jabber_id
    end
    has_value :jabber, :klass => Jabber, :default => Jabber.new

  end
end
