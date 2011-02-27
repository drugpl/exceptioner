# This model is intended to be included in Rails2.x ApplicationController 
# For Rails 3 as well as for other web frameworks you should use
# Exceptioner::Middleware
#
# Rails 2.x catch exceptions in ActionController::Base so they aren't propagated
# to underlaying middlewares. This obviously makes Exceptioner::Middleware
# useless. 

require 'exceptioner/notifier'

module Exceptioner
  module Support
    module Rails2
      module ActionController

        def self.included(base)
          base.alias_method_chain :rescue_action_in_public, :exceptioner
          base.alias_method_chain :rescue_action_locally, :exceptioner
        end

        protected
        def rescue_action_in_public_with_exceptioner(exception)
          rescue_action_in_public_without_exceptioner(exception)
          exceptioner_dispatch_exception(exception)
        end

        def rescue_action_locally_with_exceptioner(exception)
          rescue_action_locally_without_exceptioner(exception)
          exceptioner_dispatch_exception(exception) if Exceptioner.dispatch_local_requests
        end

        def exceptioner_dispatch_exception(exception)
          Notifier.dispatch(exception, :controller => self, :env => request.env)
        end

      end
    end
  end
end
