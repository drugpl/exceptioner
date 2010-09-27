# This model is intended to be included in Rails2.x ApplicationController 
# For Rails 3 as well as for other web frameworks you should use
# Exceptioner::Middleware
#
# Rails 2.x catch exceptions in ActionController::Base so they aren't propagated
# to underlaying middlewares. This obviously makes Exceptioner::Middleware
# useless. 

require 'exceptioner/notifier'

module Exceptioner
  module ActionController

    private
    def rescue_action_in_public(exception)
      super
      Notifier.dipatch(exception)
    end

    def rescue_action_locally(exception)
      super
      Notifier.dispatch(exception) if Exceptioner.dispatch_local_requests
    end

  end

end
