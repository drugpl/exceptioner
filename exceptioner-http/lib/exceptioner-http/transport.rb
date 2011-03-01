require 'uri'
require 'json'
require 'exceptioner/transport/base'
require 'exceptioner-http/request'

module Exceptioner
  module Transport
    class Http < Base
      class ConfigurationError < StandardError; end

      def init
        if running_eventmachine?
          extend EventMachineRequest
        else
          extend NetHttpRequest
        end
        validate_config
        uri = URI.parse(options[:api_uri])
        @host, @port, @path = uri.host, uri.port, uri.request_uri
      end

      def deliver(issue)
        # see corresponding request module
      end

      def running_eventmachine?
        begin
          em = Kernel.const_get(:EM)
          em.respond_to?(:reactor_running?) && em.send(:reactor_running?)
        rescue NameError
          false
        end
      end

      protected

      def validate_config
        message = "Please set API key in configuration first!"
        raise ConfigurationError, message unless config.api_key
      end

      def default_options
        { :api_uri => "http://exceptioner.com/api/0.1/issues" }
      end

      def options
        opts = {}
        [:api_key, :api_uri].each do |opt|
          value = config.send(opt)
          opts[opt] = value if value
        end
        default_options.merge(opts)
      end

      def prepare_json(issue)
        issue_hash = {
          :name => issue.exception_name,
          :message => issue.message,
          :backtrace => issue.formatted_backtrace
        }
        return { :issue => issue_hash }.to_json
      end
    end
  end
end
