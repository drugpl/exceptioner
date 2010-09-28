require 'mail'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class Email < Base
  
    cattr_accessor :sender

    cattr_accessor :recipients

    cattr_accessor :prefix

    cattr_accessor :subject

    cattr_accessor :delivery_method

    def self.deliver(exception, options = {})
      mail = prepare_email(exception, options)
      mail.deliver
    end

    def self.render(exception, options = {})
      ERB.new(template, nil, '>').result(binding)
    end

    def self.template
      @template ||= File.read(File.expand_path(File.join(File.dirname(__FILE__), 'templates', 'exception.erb')))
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

    def self.prepare_email(exception, email_options)
      options = email_options.dup
      options = default_options.merge(options)
      options[:subject] ||= "#{options[:prefix]}#{exception.message}"
      options[:body] ||= render(exception, email_options)

      mail = Mail.new(
       :from             => options[:sender], 
       :to               => options[:recipients],
       :subject          => options[:subject],
       :body             => options[:body])

      mail.delivery_method(options[:delivery_method])
      mail
    end

  end

end
