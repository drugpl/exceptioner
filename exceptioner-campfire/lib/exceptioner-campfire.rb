#TODO: How to autoload configuration? Better to avoid method_missing
require 'exceptioner-campfire/configuration'

module Exceptioner
  module Transport

    autoload :Campfire, 'exceptioner-campfire/transport'

  end
end
