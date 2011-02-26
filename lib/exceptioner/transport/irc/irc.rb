require 'isaac/bot'
require 'digest/sha1'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport
  class Irc < Base
    class_attribute :server
    class_attribute :port
    class_attribute :nick
    class_attribute :channel
    class_attribute :bot
    class_attribute :exceptions

    def self.init
      validate_config
      self.exceptions = {}

      options = default_options.merge(:channel => self.channel)
      klass = Exceptioner::Transport::Irc

      self.bot = Isaac::Bot.new do

        configure do |c|
          c.nick          = options[:nick]
          c.server        = options[:server]
          c.port          = options[:port]
          c.environment   = :test if ENV['RAILS_ENV'] == 'test'
        end

        on :connect do
          join options[:channel]
        end

        on :channel, /^!all$/ do
          empty(klass.exceptions)
          klass.exceptions.each do |hash, exp|
            print_exception(exp)
          end
        end

        on :channel, /^!last (.*)$/ do |number|
          empty(klass.exceptions)
          number = number.to_i
          sort_exceptions(klass.exceptions, :created_at)[0...number].each do |exp|
            print_exception(exp)
          end
        end

        on :channel, /^!mostly (.*)$/ do |number|
          empty(klass.exceptions)
          number = number.to_i
          sort_exceptions(klass.exceptions, :counter)[0...number].each do |exp|
            print_exception(exp)
          end
        end

        on :channel, /!help/ do
          help.each do |help_line|
            msg channel, help_line
          end
        end
        
        helpers do
          def print_exception(exp)
            msg channel, "#{exp[:created_at]} | count #{exp[:counter]} | #{exp[:link]}"
          end

          def sort_exceptions(exceptions, by)
            exceptions.values.sort_by{ |exp| exp[by] }.reverse 
          end

          def empty(exceptions)
            msg channel, "No exceptions..." if exceptions.size == 0  
          end

          def help
            ["!help - show help",
             "!all - show all exceptions",
             "!last [number] - show last [number] exceptions",
             "!mostly [number] - show the last [number] common exceptions"]
          end
        end

      end
      
      thread = Thread.new do
        self.bot.start
      end

      return self.bot, thread
    end

    def self.deliver(options = {})
      body = prepare_message(options)
      self.bot.msg self.channel, body
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

    def self.add_exception(body, exception)
      hash = Digest::SHA1.hexdigest(exception.to_s)
      self.exceptions[hash] ||= { :options => exception, :link => post_body(body), :body => body, :counter => 1, :created_at => Time.now }
      self.exceptions[hash][:counter] += 1

      exceptions[hash]
    end

    def self.validate_config
      raise "Set IRC channel in your configuration first!" unless self.channel
    end

    def self.default_options
      {
        :nick   => self.nick    || "ExceptionerBot",
        :server => self.server  || "chat.freenode.net",
        :port   => self.port    || "6667"
      }
    end

  end
end
