module Exceptioner
  class Railtie < Rails::Railtie

    initializer "exceptioner.use_rack_middleware" do |app|
      app.config.middleware.use "Exceptioner::Middleware"
    end

    initializer "exceptioner.use_rails_default" do |app|
      Exceptioner.config.environment_name ||= Rails.env
      Exceptioner.config.mail.delivery_method ||= rails_delivery(app)
      Exceptioner.config.mail.delivery_options ||= rails_delivery_options(app)
    end

    initializer "exceptioner.use_rails_logger", :after => :initialize_logger do |app|
      Exceptioner.config.logger= rails_logger(app)
    end

    rake_tasks do
      load "tasks/exceptioner.rake"
    end

    protected
    def rails_delivery(app)
      app.config.action_mailer.delivery_method 
    end

    def rails_delivery_options(app)
      app.config.action_mailer.send("#{rails_delivery(app)}_settings") if app.config.action_mailer.respond_to?("#{rails_delivery(app)}_settings")
    end

    def rails_logger(app)
      Rails.logger
    end

  end
end
