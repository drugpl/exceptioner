module Exceptioner::Transport

  class Base
    
    cattr_accessor :sender

    cattr_accessor :recipients

    cattr_accessor :prefix

    cattr_accessor :subject


    def self.deliver(exception, options = {})
      raise Exceptioner::ExceptionerError, 'Implement deliver class method in your Exceptioner::Transport::Base subclass'
    end
    
    protected
    def self.default_options
      {
        :sender => sender || 'exceptioner',
        :recipients => recipients,
        :prefix => prefix || '[ERROR] ',
        :subject => subject
      }
    end

    def self.prefixed_subject(exception, options)
      "#{options[:prefix]}#{exception.message}"
    end

  end

end
