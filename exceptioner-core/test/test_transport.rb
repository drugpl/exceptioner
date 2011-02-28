require 'exceptioner/transport/base'

module Exceptioner
  module Transport
    class Test < Base

      def deliver(*)
        @delivered = true
      end

      def delivered?
        @delivered
      end

      public :render

    end
  end
end
