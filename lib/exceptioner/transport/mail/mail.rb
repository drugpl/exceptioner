require 'mail'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class Mail < Base

    def deliver(options = {})
      mail = prepare_mail(options)
      mail.deliver
    end

    protected
    def prepare_mail(mail_options)
      options = config.attributes.merge(mail_options)
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
