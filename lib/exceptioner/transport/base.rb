require 'exceptioner/dispatchable'

module Exceptioner::Transport

  class Base
    include Exceptioner::Dispatchable

    def init
    end

    def config
      @config ||= begin
                    local_config.update_attributes(Exceptioner.config.only(local_config.attributes.keys))
                    local_config
                  end
    end

    def config_name
      self.class.name.split('::').last.downcase
    end

    def local_config
      Exceptioner.config.send(self.config_name)
    end

    def configure
      init unless initialized?
      @initialized = true
    end

    def initialized?
      @initialized
    end

    def deliver(options = {})
      raise Exceptioner::ExceptionerError, 'Implement deliver method in your Exceptioner::Transport::Base subclass'
    end

    protected
    def default_options
      {
        :sender => config.sender || 'exceptioner',
        :recipients => config.recipients,
        :prefix => config.prefix,
        :subject => config.subject
      }
    end

    def prefixed_subject(options)
      "#{options[:prefix]}#{options[:error_message]}"
    end

    def render(options = {})
      ERB.new(template, nil, '>').result(binding)
    end

    def template
      @template ||= File.read(File.expand_path(File.join(File.dirname(__FILE__), 'templates', 'exception.erb')))
    end

  end

end
