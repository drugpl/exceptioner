module Exceptioner
  class Issue
    attr_accessor :exception, :message, :backtrace, :controller, :env,
      :transports, :application_path, :gem_path
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

    def formatted_backtrace
      app_paths = Array(application_path)
      gem_paths = Array(gem_path)

      [app_paths, gem_paths].each do |paths|
        paths.map! { |path| Regexp.new("^" + Regexp.escape(path)) } # replace path only at the line beginning
      end

      backtrace.collect! do |line|
        app_paths.each do |path_regexp|
          line.sub!(path_regexp, "APPLICATION_PATH")
        end
        gem_paths.each do |path_regexp|
          line.sub!(path_regexp, "GEM_PATH")
        end
        line
      end

      backtrace.join("\n")
    end

    protected

      def allowed_options?(options)
        (options.keys - allowed_options).empty?
      end

      def allowed_options
        [:exception, :controller, :env, :message, :backtrace, :params, :application_path, :gem_path]
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

      def config
        @config
      end
  end
end