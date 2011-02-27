require 'exceptioner/support/rails2/action_controller'
require 'exceptioner/middleware'

module Exceptioner
  module Support
    module Rails2

      def self.init
        if defined?(::ActionController::Base)
          ::ActionController::Base.send(:include, Exceptioner::Support::Rails2::ActionController)
        end

        if defined?(::Rails.configuration) && ::Rails.configuration.respond_to?(:middleware)
          ::Rails.configuration.middleware.insert_after 'ActionController::Failsafe', Exceptioner::Middleware
        end

        Exceptioner.config.environment_name = RAILS_ENV if defined?(RAILS_ENV)
        Exceptioner.config.logger = Rails.logger

      end

    end
  end
end

Exceptioner::Support::Rails2.init
