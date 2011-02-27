module Exceptioner
  module Utils
    extend self

    def classify_transports(transports)
      transports.collect { |transport| classify_transport(transport) }
    end

    def classify_transport(transport)
      begin
        transport.is_a?(Class) ? transport : ::Exceptioner::Transport.const_get(transport.to_s.camelize)
      rescue NameError
        raise Exceptioner::ExceptionerError, "No such transport: #{transport.to_s}"
      end
    end

    def filter_backtrace(backtrace, options = {})
      app_paths = Array(options[:application_path] || Exceptioner.config.application_path)
      gem_paths = Array(options[:gem_path] || Exceptioner.config.gem_path)

      backtrace.collect do |line|
        app_paths.each do |path|
          sub_at_begining(line, path, "APPLICATION_PATH")
        end
        gem_paths.each do |path|
          sub_at_begining(line, path, "GEM_PATH")
        end
        line
      end
    end

    private
    def sub_at_begining(str, pattern, replacement)
      re = Regexp.new("^"+Regexp.escape(pattern))
      str.sub!(re, replacement)
    end
  end
end
