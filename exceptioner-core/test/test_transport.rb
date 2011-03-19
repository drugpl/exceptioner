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

  class Configuration
    class Testing < Configuration
    end
    has_value :testing, :klass => Testing, :default => Testing.new
  end
end
