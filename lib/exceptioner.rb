require 'exceptioner/core_ext/class/attribute_accessors'
require 'exceptioner/core_ext/module/attribute_accessors'

module Exceptioner

  class ExceptionerError < StandardError; end

  autoload :Middleware,       'exceptioner/middleware'
  autoload :ActionController, 'exceptioner/action_controller'
  
  module Transport
    autoload :Email, 'exceptioner/transport/email/email'
    autoload :ActionMailer, 'exceptioner/transport/action_mailer/action_mailer'
  end

  # Define how to deliver exceptions data. 
  # For example :mail, :jabber, :irc
  mattr_accessor :transports
  @@transports = [:mail]

  # If true exceptions raised by local requests will be delivered
  # Note it's Rails 2.x specific setting
  mattr_accessor :dispatch_local_requests
  @@dispatch_local_requests = false

  def self.setup
    yield self
  end

  def self.email
    Transport::Email
  end

end
