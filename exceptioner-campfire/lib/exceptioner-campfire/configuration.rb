require 'exceptioner/configuration'

module Exceptioner
  class Configuration

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

  end
end
