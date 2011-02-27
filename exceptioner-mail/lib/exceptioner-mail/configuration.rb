require 'exceptioner/configuration'

module Exceptioner
  class Configuration

    class Mail < Configuration
      has_value :delivery_method, :klass => Symbol, :default => :sendmail
      has_value :delivery_options, :klass => Hash, :default => {}
    end
    has_value :mail, :klass => Mail, :default => Mail.new

  end
end
