require 'json'
require 'uri'
require 'net/http'
require 'exceptioner/transport/base'


module Exceptioner::Transport
  class Http < Base
    class ConfigError < StandardError; end
    class HttpError   < StandardError; end

    class_attribute :api_uri
    class_attribute :api_key
    class_attribute :api_version

    class << self
      def init
        validate_config
      end

      def deliver(exception_hash = {})
        uri = URI.parse(options[:api_uri])
        request = Net::HTTP::Post.new(uri.request_uri)
        request["Content-Type"] = "application/json"
        request["API-Key"] = options[:api_key]
        request.body = prepare_json(exception_hash)
        response = Net::HTTP.new(uri.host, uri.port).start do |http|
          http.request(request)
        end
        handle_error(request, response) unless response.kind_of? Net::HTTPSuccess
      end

      protected

      def handle_error(request, response)
        message = "HTTP error ocurred. I guess you're not happy with that."
        raise HttpError, message
      end

      def validate_config
        message = "Please set API key in configuration first!"
        raise ConfigError, message unless self.api_key
      end

      def default_options
        {
          :api_uri => "http://exceptioner.com/api/0.1/issues",
        }
      end

      def options
        opts = {}
        [:api_key, :api_uri].each do |opt|
          value = self.send(opt)
          opts[opt] = value if value
        end
        default_options.merge(opts)
      end

      def prepare_json(exception_hash)
        issue = {
          :name => exception_hash[:exception_class].name,
          :message => exception_hash[:error_message],
          :backtrace => exception_hash[:backtrace].join("\n")
        }
        return { :issue => issue }.to_json
      end
    end
  end
end
