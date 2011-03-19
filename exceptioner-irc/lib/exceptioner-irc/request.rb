require 'cgi'

module Exceptioner
 module Transport
   class Irc < Base
      module EventMachineDeliverAgent
        def deliver(issue)
          options = config.attributes
          body = render(issue)
        
          http = EventMachine::Protocols::HttpClient.request(
              :host => "http://pastebin.com",
                :port => 80,
                :request => "/api_public.php",
                :query_string => "paste_code=CGI.escape(body)&paste_private=1"
                )
          http.callback {|response|
            exception = add_exception(body, issue, response[:content], options)
            body = prepare_message(exception)
            @bot.msg config.channel, body
          }
        end
      end

      module NetHtppDeliverAgent
        def deliver(issue)
          options = config.attributes
          body = render(issue)

          response = ::Net::HTTP.post_form(URI.parse("http://pastebin.com/api_public.php"),
                                          { :paste_code => body, :paste_private => 1 }).body
          exception = add_exception(body, issue, response, options)
          body = prepare_message(exception)
          @bot.msg config.channel, body
        end
      end
   end
 end 
end
