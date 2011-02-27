require 'isaac/bot'
require 'digest/sha1'
require 'net/http'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport
  class Irc < Base
    attr_reader :bot

    def init
      validate_config
      @exceptions = {}

      options = default_options.merge(:channel => config.channel)
      klass = Exceptioner::Transport::Irc

      @bot = Isaac::Bot.new do

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
        @bot.start
      end

      return @bot, thread
    end

    def deliver(issue)
      body = prepare_message(issue)
      @bot.msg config.channel, body
    end

    def prepare_message(issue)
      options = config.attributes
      body = render(issue)
      exception = add_exception(body, issue, options)
      "Exception!: " + exception[:link]
    end

    def post_body(body, options = { :provider => :pastebin })
      case options[:provider]
        when :pastebin
          ::Net::HTTP.post_form(URI.parse("http://pastebin.com/api_public.php"), { :paste_code => body, :paste_private => 1 }).body
      end
    end

    def add_exception(body, issue, options = {})
      hash = Digest::SHA1.hexdigest(issue.backtrace.to_s + issue.exception.to_s)
      @exceptions[hash] ||= { :issue => issue, :link => post_body(body, options), :body => body, :counter => 1, :created_at => Time.now }
      @exceptions[hash][:counter] += 1

      @exceptions[hash]
    end

    def validate_config
      raise "Set IRC channel in your configuration first!" unless config.channel
    end

    def default_options
      {
        :nick   => config.nick    || "ExceptionerBot",
        :server => config.server  || "chat.freenode.net",
        :port   => config.port    || "6667"
      }
    end

  end
end
