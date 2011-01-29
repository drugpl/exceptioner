require 'exceptioner/dispatchable' 

module Exceptioner::Transport

  class Base
    extend Exceptioner::Dispatchable
    
    class_attribute :sender

    class_attribute :recipients

    class_attribute :prefix

    class_attribute :subject

    def self.init
    end

    def self.configure
      init unless initialized?
      @initialized = true
    end

    def self.initialized?
      @initialized
    end

    def self.deliver(options = {})
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

    def self.prefixed_subject(options)
      "#{options[:prefix]}#{options[:error_message]}"
    end
    
    def self.render(options = {})
      ERB.new(template, nil, '>').result(binding)
    end

    def self.template
      @template ||= File.read(File.expand_path(File.join(File.dirname(__FILE__), 'templates', 'exception.erb')))
    end
    

  end

end
