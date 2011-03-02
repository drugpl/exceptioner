module Exceptioner
  module Mail
    class Railtie < Rails::Railtie

      initializer "exceptioner.use_rails_default" do |app|
        Exceptioner.config.mail.delivery_method ||= rails_delivery(app)
        Exceptioner.config.mail.delivery_options ||= rails_delivery_options(app)
      end

      protected
      def rails_delivery(app)
        app.config.action_mailer.delivery_method
      end

      def rails_delivery_options(app)
        app.config.action_mailer.send("#{rails_delivery(app)}_settings") if app.config.action_mailer.respond_to?("#{rails_delivery(app)}_settings")
      end

    end
  end
end
