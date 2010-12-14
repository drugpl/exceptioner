require 'exceptioner/core_ext/class/attribute'
require 'exceptioner/core_ext/module/attribute_accessors'
require 'exceptioner/railtie' if defined?(Rails::Railtie)

module Exceptioner

  class ExceptionerError < StandardError; end

  autoload :Middleware,       'exceptioner/middleware'
  autoload :ActionController, 'exceptioner/action_controller'
  
  module Transport
    autoload :Mail, 'exceptioner/transport/mail/mail'
    autoload :Jabber, 'exceptioner/transport/jabber/jabber'
  end

  # Define how to deliver exceptions data. 
  # For example :mail, :jabber, :irc
  mattr_accessor :transports
  @@transports = [:mail]

  # If true exceptions raised by local requests will be delivered
  # Note it is Rails 2.x specific setting
  mattr_accessor :dispatch_local_requests
  @@dispatch_local_requests = false

  def self.setup
    yield self
  end

  def self.mail
    Transport::Mail
  end

  def self.jabber
    Transport::Jabber
  end

end
