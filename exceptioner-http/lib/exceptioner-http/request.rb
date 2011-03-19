module Exceptioner
  module Transport
    class Http < Base
      class RequestError < StandardError; end

      module EventMachineRequest
        def deliver(issue)
          http = ::EM::Protocols::HttpClient.request(
            :host => @host,
            :port => @port,
            :request => @path,
            :verb => 'POST',
            :content => prepare_json(issue),
            :contenttype => "application/json",
            :custom_headers => { "API-Key" =>  options[:api_key] }
          )
          http.errback do |response|
            message = "HTTP error ocurred. I guess you're not happy with that."
            raise RequestError, message
          end
        end
      end

      module NetHttpRequest
        def deliver(issue)
          http = ::Net::HTTP.new(@host, @port)
          headers = {
            "Content-Type" => "application/json",
            "API-Key" => options[:api_key]
          }
          response, data = http.post(@path, prepare_json(issue), headers)
          unless response.kind_of? Net::HTTPSuccess
            message = "HTTP error ocurred. I guess you're not happy with that."
            raise RequestError, message
          end
        end
      end
    end
  end
end
