require 'exceptioner/dispatchable'

module Exceptioner::Transport

  class Base
    extend Exceptioner::Dispatchable

    def self.init
    end

    def self.config
      @config ||= begin
                    local_config.update_attributes(Exceptioner.config.only(local_config.attributes.keys))
                    local_config
                  end
    end

    def self.config_name
      self.name.split('::').last.downcase
    end

    def self.local_config
      Exceptioner.config.send(self.config_name)
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
        :sender => config.sender || 'exceptioner',
        :recipients => config.recipients,
        :prefix => config.prefix,
        :subject => config.subject
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
