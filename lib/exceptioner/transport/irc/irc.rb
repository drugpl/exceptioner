require 'isaac/bot'
require 'digest/sha1'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport
  class IRC < Base
    class_attribute :server
    class_attribute :port
    class_attribute :nick
    class_attribute :channel
    class_attribute :bot
    class_attribute :exceptions

    def self.init(options)
      options = options.dup
      options = default_options.merge(options)

      self.bot = Isaac::Bot.new do
        configure do |c|
          c.nick   = options[:nick]
          c.server = options[:server]
          c.port   = options[:port]
        end

        on :connect do
          join self.channel || "#drug.pl"
        end

        on :channel, /!all/ do
          self.exceptions.each do |exp|
            msg channel, exp[:link]
          end
        end

      end

      thread = Thread.new do
        self.bot.start
      end

      self.exceptions = {}

      return self.bot, thread
    end

    def self.deliver(options = {})
      body = prepare_message(options)
      self.bot.msg '#drug.pl', body
    end

    def self.prepare_message(options)
      body = render(options)
      exception = add_exception(body, options)
      "Exception!: " + exception[:link]
    end

    def self.post_body(body, options = { :provider => :pastebin })
      case options[:provider]
        when :pastebin
          Net::HTTP.post_form(URI.parse("http://pastebin.com/api_public.php"), { :paste_code => body, :paste_private => 1 }).body
      end
    end

    def self.default_options
      {
          :server => self.server  || "chat.freenode.net",
          :port   => self.port    || 6667,
          :nick   => self.nick    || "ExceptionerBot"
      }.merge!(super)
    end

    def self.add_exception(body, exception)
      hash = Digest::SHA1.hexdigest(exception.to_s)
      self.exceptions[hash] ||= { :options => exception, :link => post_body(body), :body => body, :counter => 1 }
      self.exceptions[hash][:counter] += 1

      exceptions[hash]
    end

  end
end