require 'xmpp4r/client'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class Jabber < Base
    
    class_attribute :jabber_id

    class_attribute :password

    def deliver(options = {})
      messages = prepare_messages(options)
      authenticate do |client|
        messages.each do |message|
          client.send(message)
        end
      end
    end

    def register
      raise "Set jabber_id in your configuration first!" unless self.class.jabber_id
      connect do |client|
        client.register(self.class.password)
      end
    end

    def subscribe(options = {})
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
    def prepare_messages(message_options)
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

    def connect
      jid = ::Jabber::JID.new(self.class.jabber_id)
      client = ::Jabber::Client.new(jid)
      client.connect
      yield client
    end

    def authenticate
      connect do |client|
        client.auth(self.class.password)
        yield client
      end
    end
  end

end
