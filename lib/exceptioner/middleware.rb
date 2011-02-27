require 'exceptioner/notifier'

module Exceptioner
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        response = @app.call(env)
      rescue Exception => exception
        Notifier.dispatch(exception, :controller => env['action_controller.instance'], :env => env)
      end
        raise exception
      if env['rack.exception']
        Notifier.dispatch(env['rack.exception'], :controller => env['action_controller.instance'], :env => env)
      end

      response
    end

  end
end
