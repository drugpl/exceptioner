require 'action_mailer'
require 'action_mailer/version'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class ActionMailer < Email

    class ExceptionsMailer < ::ActionMailer::Base

      def notification(exception, options = {})
        mail(::Exceptioner::Transport::Email.determine_email_options(exception, options))
      end

    end

    def self.deliver(exception, options = {})
      ExceptionsMailer.notification(exception, options).deliver
    end

  end

end
