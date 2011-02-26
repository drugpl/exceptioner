require 'xmpp4r/client'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class Jabber < Base

    def self.deliver(options = {})
      messages = prepare_messages(options)
      authenticate do |client|
        messages.each do |message|
          client.send(message)
        end
      end
    end

    def self.register
      raise "Set jabber_id in your configuration first!" unless config.jabber_id
      connect do |client|
        client.register(config.password)
      end
    end

    def self.subscribe(options = {})
      options = default_options.merge(options)

      authenticate do |client|
        Array(options[:recipients]).each do |recipient|
          presence = ::Jabber::Presence.new
          presence.set_type(:subscribe)
          presence.set_to(recipient)
          client.send(presence)
        end
      end
    end

    protected
    def self.prepare_messages(message_options)
      options = message_options.dup
      options = default_options.merge(options)
      options[:body] ||= render(message_options)

      messages = []
      Array(options[:recipients]).each do |recipient|
        message = ::Jabber::Message.new(recipient, options[:body])
        message.set_type(:chat)
        messages << message
      end
      messages
    end

    def self.connect
      jid = ::Jabber::JID.new(config.jabber_id)
      client = ::Jabber::Client.new(jid)
      client.connect
      yield client
    end

    def self.authenticate
      connect do |client|
        client.auth(config.password)
        yield client
      end
    end
  end

end
