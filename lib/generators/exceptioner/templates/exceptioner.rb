# Use this setup block to configure options available in Exceptioner
Exceptioner.setup do |config|

  # Define how to deliver information about exception
  # Available options are: email
  # config.transports = [:mail]

  # The section below regards mail transport only

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

end
