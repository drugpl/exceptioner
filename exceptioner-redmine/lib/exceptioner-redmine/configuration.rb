require 'exceptioner/configuration'

module Exceptioner

  class Configuration

    class Redmine < Configuration
      has_value :project, :klass => String
      has_value :options, :klass => Hash
    end
    has_value :redmine, :klass => Redmine, :default => Redmine.new

  end

end
