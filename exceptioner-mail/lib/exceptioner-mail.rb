#TODO: How to autoload configuration? Better to avoid method_missing
require 'exceptioner-mail/configuration'
require 'exceptioner-mail/railtie' if defined?(Rails::Railtie)

module Exceptioner
  module Transport

    autoload :Mail, 'exceptioner-mail/transport'

  end
end
