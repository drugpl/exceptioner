module Exceptioner
  class Railtie < Rails::Railtie

    initializer "exceptioner.use_rack_middleware" do |app|
      app.config.middleware.use "Exceptioner::Middleware"
    end

    initializer "exceptioner.use_rails_default" do |app|
      Exceptioner.environment_name ||= Rails.env
      Exceptioner.mail.delivery_method ||= rails_delivery(app)
      Exceptioner.mail.delivery_options ||= rails_delivery_options(app)
    end

    rake_tasks do
      load "exceptioner/tasks/exceptioner.rake"
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
