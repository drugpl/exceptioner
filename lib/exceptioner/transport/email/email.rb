require 'mail'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class Email < Base
  
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
    
    def self.determine_email_options(exception, email_options)
      options = {}
      options[:from]    ||= options[:sender]
      options[:to]      ||= options[:recipients]
      options[:subject] ||= prefixed_subject(exception, options)
      options[:body]    ||= render(exception, email_options)
      options.merge!(default_options)
    end

    protected
    def self.default_options
      super.merge(:delivery_method => :sendmail)
    end

    def self.prepare_email(exception, email_options)
      options = determine_email_options(exception, email_options)

      mail = Mail.new(options)

      mail.delivery_method(options[:delivery_method])
      mail
    end

  end

end
