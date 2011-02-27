require 'xmpp4r/client'
require 'exceptioner/transport/base'

module Exceptioner
  module Transport
    class Jabber < Base
      def deliver(issue)
        messages = prepare_messages(issue)
        authenticate do |client|
          messages.each do |message|
            client.send(message)
          end
        end
      end

      def register
        raise "Set jabber_id in your configuration first!" unless config.jabber_id
        connect do |client|
          client.register(config.password)
        end
      end

      def subscribe(options = {})
        options = config.attributes.merge(options)

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
      def prepare_messages(issue)
        options = config.attributes
        options[:body] ||= render(issue)

        messages = []
        Array(options[:recipients]).each do |recipient|
          message = ::Jabber::Message.new(recipient, options[:body])
          message.set_type(:chat)
          messages << message
        end
        messages
      end

      def connect
        jid = ::Jabber::JID.new(config.jabber_id)
        client = ::Jabber::Client.new(jid)
        client.connect
        yield client
      end

      def authenticate
        connect do |client|
          client.auth(config.password)
          yield client
        end
      end
    end
  end
end
