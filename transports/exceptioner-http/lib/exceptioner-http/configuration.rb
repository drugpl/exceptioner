require 'exceptioner/configuration'

module Exceptioner

  class Configuration

    class Http < Configuration
      has_value :api_uri, :klass => String
      has_value :api_key, :klass => String
    end
    has_value :http, :klass => Http, :default => Http.new

  end

end
