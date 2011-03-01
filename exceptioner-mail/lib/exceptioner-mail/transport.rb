require 'mail'
require 'exceptioner/transport/base'

module Exceptioner
  module Transport
    class Mail < Base

      def deliver(issue)
        mail = prepare_mail(issue)
        mail.deliver
      end

      protected
      def prepare_mail(issue)
        options = config.attributes
        options[:subject] ||= prefixed_subject(options)
        options[:body]    ||= render(issue)

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
end
