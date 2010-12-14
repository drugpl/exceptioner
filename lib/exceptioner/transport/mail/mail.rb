require 'mail'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class Mail < Base
    DEFAULT_SENDER_ADDRESS = 'exceptioner@exceptioner.net'

    class_attribute :delivery_method

    class_attribute :delivery_options

    def self.deliver(exception, options = {})
      mail = prepare_mail(exception, options)
      mail.deliver
    end

    def self.determine_mail_options(exception, mail_options)
      options = {}
      options[:from]    ||= options[:sender]
      options[:to]      ||= options[:recipients]
      options[:subject] ||= prefixed_subject(exception, options)
      options[:body]    ||= render(exception, mail_options)
      options.merge!(default_options)
    end

    protected
    def self.default_options
      {
        :delivery_method => delivery_method,
        :delivery_options => delivery_options,
        :sender => DEFAULT_SENDER_ADDRESS
      }.merge!(super)
    end

    def self.prepare_mail(exception, mail_options)
      options = mail_options.dup
      options = default_options.merge(options)
      options[:subject] ||= prefixed_subject(exception, options)
      options[:body] ||= render(exception, mail_options)

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
