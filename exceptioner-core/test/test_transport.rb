require 'exceptioner/transport/base'

module Exceptioner
  module Transport
    class Testing < Base

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
