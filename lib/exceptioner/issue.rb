module Exceptioner
  class Issue
    attr_accessor :exception, :message, :backtrace, :controller, :env
    attr_writer :params

    def initialize(options = {})
      raise Exceptioner::ExceptionerError, "Unallowed options" unless allowed_options?(options)
      initialize_by_options(options)
      initialize_by_exception(options[:exception]) if options[:exception]
    end

    def params
      @controller ? @controller.params : @params
    end

    def exception_name
      @exception.class.to_s if @exception
    end

    def controller_name
      @controller.controller_name if @controller
    end

    protected

      def allowed_options?(options)
        (options.keys - allowed_options).empty?
      end

      def allowed_options
        [:exception, :controller, :env, :message, :backtrace, :params]
      end

      def initialize_by_options(options)
        options.each do |key, value|
          send("#{key}=", value)
        end
      end

      def initialize_by_exception(exception)
        self.backtrace  = exception.backtrace
        self.message    = exception.message
      end
  end
end