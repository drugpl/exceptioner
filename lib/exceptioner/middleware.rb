require 'exceptioner/notifier'

module Exceptioner
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue Exception => exception
        Notifier.dispatch(exception) 
        raise exception
      end
    end

  end
end
