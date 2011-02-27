require 'exceptioner/core_ext/class/attribute'
require 'exceptioner/core_ext/module/attribute_accessors'
require 'exceptioner/core_ext/string/inflections'
require 'exceptioner/configuration'
require 'exceptioner/dispatchable'
require 'exceptioner/version'
require 'exceptioner/railtie' if defined?(Rails::Railtie)

module Exceptioner
  extend Dispatchable

  class ExceptionerError < StandardError; end

  autoload :Middleware,       'exceptioner/middleware'
  autoload :Notifier,         'exceptioner/notifier'
  autoload :Utils,            'exceptioner/utils'

  module Transport
    autoload :Mail,     'exceptioner/transport/mail/mail'
    autoload :Jabber,   'exceptioner/transport/jabber/jabber'
    autoload :Redmine,  'exceptioner/transport/redmine/redmine'
    autoload :Irc,      'exceptioner/transport/irc/irc'
    autoload :Campfire, 'exceptioner/transport/campfire/campfire'
    autoload :Http,     'exceptioner/transport/http/http'
  end

  def self.setup
    yield config if block_given?
    init_transports
  end

  def self.init
    add_default_dispatchers
  end

  def self.notify(exception, options = {})
    Notifier.dispatch(exception, options)
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.reset_config
    @config = nil
    @@transport_instances = nil
  end

  def self.reset_dispatchers
    clear_dispatchers
    add_default_dispatchers
  end

  def self.add_default_dispatchers
    disallow_development_environment
    disallow_ignored_exceptions
  end

  def self.disallow_development_environment
    dispatch do |exception|
      ! config.development_environments.include?(config.environment_name)
    end
  end

  def self.disallow_ignored_exceptions
    dispatch do |exception|
      ! Array(config.ignore).collect(&:to_s).include?(exception.class.name)
    end
  end

  def self.init_transports
    config.transports.each do |transport|
      transport_instance(transport).configure
    end
  end

  def self.transport_instance(transport)
    @@transport_instances ||= { }
    @@transport_instances[transport] ||= Utils.classify_transport(transport).new
  end
end

require 'exceptioner/support/rails2' if defined?(Rails::VERSION::MAJOR) && Rails::VERSION::MAJOR == 2

Exceptioner.init
