require 'mail'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class Mail < Base
    DEFAULT_SENDER_ADDRESS = 'exceptioner@exceptioner.net'

    class_attribute :delivery_method

    class_attribute :delivery_options

    def deliver(options = {})
      mail = prepare_mail(options)
      mail.deliver
    end

    protected
    def default_options
      {
        :delivery_method => self.class.delivery_method,
        :delivery_options => self.class.delivery_options,
        :sender => DEFAULT_SENDER_ADDRESS
      }.merge!(super)
    end

    def prepare_mail(mail_options)
      options = mail_options.dup
      options = default_options.merge(options)
      options[:subject] ||= prefixed_subject(options)
      options[:body]    ||= render(mail_options)

      mail = ::Mail.new(
        :from             => options[:sender], 
        :to               => options[:recipients],
        :subject          => options[:subject],
        :body             => options[:body]
      )
      mail.delivery_method(options[:delivery_method], options[:delivery_options] || {}) if options[:delivery_method]
      mail
    end

  end

end
