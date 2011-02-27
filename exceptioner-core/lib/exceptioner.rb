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

  def self.setup
    yield config if block_given?
  end

  def self.config
    @config ||= Configuration.new(:logger => Logger.new('exceptioner.log'))
  end

  def self.notifier
    @notifier ||= Notifier.new(config)
  end

  def self.destroy
    @config = nil
    @notifier = nil
  end

  def self.logger
    config.logger
  end

end

require 'exceptioner/support/rails2' if defined?(Rails::VERSION::MAJOR) && Rails::VERSION::MAJOR == 2
