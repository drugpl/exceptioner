require 'xmpp4r/client'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class Jabber < Base
    
    class_attribute :jabber_id

    class_attribute :password

    def self.deliver(options = {})
      messages = prepare_messages(options)
      connect do |client|
        messages.each do |message|
          client.send(message)
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
      jid = ::Jabber::JID.new(self.jabber_id)      
      client = ::Jabber::Client.new(jid)
      client.connect
      client.auth(self.password)
      yield client
    end

  end

end
