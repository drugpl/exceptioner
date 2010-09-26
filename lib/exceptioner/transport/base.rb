module Exceptioner::Transport

  class Base

    def self.deliver(exception, options = {})
      raise Exceptioner::ExceptionerError, 'Implement deliver class method in your Exceptioner::Transport::Base subclass'
    end

  end

end
