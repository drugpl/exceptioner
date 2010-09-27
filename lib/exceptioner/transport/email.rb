require 'mail'
require 'erb'
require 'exceptioner/transport/base'

module Exceptioner::Transport

  class Email < Base
  
    cattr_accessor :sender

    cattr_accessor :recipients

    cattr_accessor :prefix

    cattr_accessor :subject

    cattr_accessor :delivery_method

    def self.deliver(exception, options = {})
      email_options = default_options.merge(options)
      email_options[:subject] ||= "#{options[:prefix]}#{exception.message}"
      email_options[:body] ||= render(exception, email_options)
      send(email_options)
    end

    def self.render(exception, options = {})
      ERB.new(template, nil, '>').result(binding)
    end

    def self.template
      @template ||= File.read(File.expand_path(File.join(File.dirname(__FILE__), 'templates', 'exception.erb')))
    end

    def self.send(options = {})
      mail = Mail.new do
        from    options[:sender]
        to      options[:recipients]
        subject options[:subject]
        body    options[:body]
      end
      mail.delivery_method options[:delivery_method]
      mail.deliver
    end

    protected
    def self.default_options
      {
        :sender => sender || 'exceptioner',
        :recipients => recipients,
        :prefix => prefix || '[ERROR] ',
        :subject => subject,
        :delivery_method => :sendmail
      }
    end

  end

end
