#TODO: How to autoload configuration? Better to avoid method_missing
require 'exceptioner-jabber/configuration'

module Exceptioner
  module Transport

    autoload :Jabber, 'exceptioner-jabber/transport'

  end
end
