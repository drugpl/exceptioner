require 'exceptioner/notifier'

module Exceptioner
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      notifier = Exceptioner.notifier

      begin
        response = @app.call(env)
      rescue Exception => exception
        notifier.dispatch(options(env).merge(:exception => exception))
        raise exception
      end
      if env['rack.exception']
        notifier.dispatch(options(env).merge(:exception => env['rack.exception']))
      end

      response
    end

    def options(env)
      {
        :controller => env['action_controller.instance'],
        :env => env
      }
    end
  end
end
