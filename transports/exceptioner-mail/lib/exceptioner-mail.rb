#TODO: How to autoload configuration? Better to avoid method_missing
require 'exceptioner-mail/configuration'

module Exceptioner
  module Transport

    autoload :Mail, 'exceptioner-mail/transport'

  end
end
