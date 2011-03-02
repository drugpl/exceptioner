module Exceptioner
  class Railtie < Rails::Railtie

    initializer "exceptioner.use_rack_middleware" do |app|
      app.config.middleware.use "Exceptioner::Middleware"
    end

    initializer "exceptioner.use_rails_default" do |app|
      Exceptioner.config.environment_name ||= Rails.env
    end

    initializer "exceptioner.use_rails_logger", :after => :initialize_logger do |app|
      Exceptioner.config.logger= rails_logger(app)
    end

    rake_tasks do
      load "tasks/exceptioner.rake"
    end

    protected
    def rails_logger(app)
      Rails.logger
    end

  end
end
