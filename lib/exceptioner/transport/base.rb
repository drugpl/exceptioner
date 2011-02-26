require 'exceptioner/dispatchable'

module Exceptioner::Transport

  class Base
    extend Exceptioner::Dispatchable

    class_attribute :sender

    class_attribute :recipients

    class_attribute :prefix

    class_attribute :subject

    def init
    end

    def configure
      init unless initialized?
      @initialized = true
    end

    def initialized?
      @initialized
    end

    def deliver(issue)
      raise Exceptioner::ExceptionerError, 'Implement deliver method in your Exceptioner::Transport::Base subclass'
    end

    protected
    def default_options
      {
        :sender => self.class.sender || 'exceptioner',
        :recipients => self.class.recipients,
        :prefix => self.class.prefix || '[ERROR] ',
        :subject => self.class.subject
      }
    end

    def prefixed_subject(options)
      "#{options[:prefix]}#{options[:error_message]}"
    end

    def render(issue)
      ERB.new(template, nil, '>').result(binding)
    end

    def template
      @template ||= File.read(File.expand_path(File.join(File.dirname(__FILE__), 'templates', 'exception.erb')))
    end


  end

end
