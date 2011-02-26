module Exceptioner
  class Issue
    attr_reader :exception, :controller, :env

    def initialize(exception, controller, env)
      @exception = exception
      @controller = controller
      @env = env
    end

    def exception_name
      @exception.class.to_s
    end

    def backtrace
      @exception.backtrace
    end

    def message
      @exception.message
    end

    def params
      @controller.params
    end

    def controller_name
      @controller.controller_name
    end
  end
end