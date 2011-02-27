require 'exceptioner/configuration'
require 'exceptioner/dispatchable'
require 'exceptioner/version'
require 'exceptioner/railtie' if defined?(Rails::Railtie)

module Exceptioner
  class ExceptionerError < StandardError; end

  autoload :Middleware,       'exceptioner/middleware'
  autoload :Notifier,         'exceptioner/notifier'
  autoload :Utils,            'exceptioner/utils'
  autoload :Issue,            'exceptioner/issue'

  module Transport
    autoload :Mail,     'exceptioner/transport/mail/mail'
    autoload :Jabber,   'exceptioner/transport/jabber/jabber'
    autoload :Redmine,  'exceptioner/transport/redmine/redmine'
    autoload :Irc,      'exceptioner/transport/irc/irc'
    autoload :Campfire, 'exceptioner/transport/campfire/campfire'
    autoload :Http,     'exceptioner/transport/http/http'
  end

  def self.setup
    @config = yield config if block_given?
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.notifier
    @notifier ||= Notifier.new(config)
  end

  def self.destroy
    @config = nil
    @notifier = nil
  end
end

require 'exceptioner/support/rails2' if defined?(Rails::VERSION::MAJOR) && Rails::VERSION::MAJOR == 2
