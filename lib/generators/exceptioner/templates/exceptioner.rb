# Use this setup block to configure options available in Exceptioner
Exceptioner.setup do |config|

  # Define how to deliver information about exception
  # Available options are: mail, :jabber
  # config.transports = [:mail]

  # Environments for which raised exceptions won't be dispatched
  # config.development_environments = %w[development test cucumber]

  # Name of current environment. For Rails it gets Rails.env by default
  # config.environment_name = Rails.env

  # Specify list of ignored exceptions.
  # By default ActiveRecord::RecordNotFound, ActionController::RoutingError and
  # ActionController::UnknownAction are ignored.
  # config.ignore += %w[ActionController::InvalidAuthenticityToken]

  # ### The section below regards mail transport only ###

  # Set message recipients
  # config.mail.recipients = %w[bofh@yourapp.com dev@yourapp.com]

  # Set delivery method and options.
  # Values are forwarded to underlying mail gem
  # To see available options visit https://github.com/mikel/mail
  # config.mail.delivery_method = :smtp
  # config.mail.delivery_options = { :address => 'smtp.example.com' }

  # Custom FROM header
  # config.mail.sender = 'exceptions@yourapp.com'

  # Custom subject
  # Note that prefix is appended to subject.
  # If you want to get rid of prefix just set it to nil
  # config.mail.subject = 'OMG Exception occurred in myapp.com'

  # Prefix prepended to email subject
  # config.mail.prefix = '[ERROR] '

  # ### The section below regards jabber/xmpp transport only ###

  # List JIDs which we'll delivery exceptions to
  # config.jabber.recipients = %w[jid@jabber.org myname@gmail.com]

  # Following settings are currently REQUIRED.
  # We have to log in as user with following credentials:

  # Sender's JID
  # config.jabber.jabber_id = 'server@jabber.org'

  # Sender's password
  # config.jabber.password = 'SECRETXXX'

  # redmine
  # config.redmine.connection do
  #   self.site     = 'http://your.redmine.org'
  #   self.user     = 'user' # or api key
  #   self.password = 'pass'
  # end
  # config.redmine.project = 'project_id_or_identifier'


end
