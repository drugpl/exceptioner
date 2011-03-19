require 'isaac/bot'
require 'digest/sha1'
require 'net/http'
require 'exceptioner/transport/base'
require 'exceptioner-irc/request'

module Exceptioner
  module Transport
    class Irc < Base
      attr_reader :bot, :exceptions

      def initialize(config)
        super
        validate_config
        @exceptions = {}

        if running_eventmachine?
          extend EventMaschineDeliverAgent
        else
          extend NetHtppDeliverAgent
        end

        options = default_options.merge(:channel => config.channel)
        klass = self

        @bot = Isaac::Bot.new do

          @_klass = klass

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
            print_sorted_exceptions(:created_at, exceptions.size)
          end

          on :channel, /\A!last\z/ do
            print_sorted_exceptions(:created_at, 1)
          end

          on :channel, /^!last (.*)$/ do |number|
            print_sorted_exceptions(:created_at, number.to_i)
          end

          on :channel, /\A!mostly\z/ do
            print_sorted_exceptions(:counter, 1)
          end

          on :channel, /^!mostly (.*)$/ do |number|
            print_sorted_exceptions(:counter, number.to_i)
          end

          on :channel, /hoptoad/ do 
            msg channel, "        ___"
            msg channel, "       {o,o}"
            msg channel, "       |)__)"
            msg channel, "       -\"-\"-"
            msg channel, "      HOPTOAD?"
            msg channel, "       O RLY?"
            msg channel, "           "
          end

          on :channel, /!help/ do
            help.each do |help_line|
              msg channel, help_line
            end
          end

          helpers do

            def exceptions(klass = @_klass)
              klass.exceptions
            end

            def print_exception(exp)
              msg channel, "#{exp[:issue].exception.class} | #{exp[:link]} | #{exp[:created_at]} | #{exp[:counter]} times"
            end

            def sort_exceptions(attribute)
              if exceptions.size > 0
                exceptions.values.sort_by{ |exp| exp[attribute] }.reverse
              else
                msg channel, "No exceptions..."
                return []
              end
            end

            def print_sorted_exceptions(attribute, number)
              sort_exceptions(attribute)[0...number].each do |exp|
                print_exception(exp)
              end
            end

            def empty(exceptions)
              msg channel, "No exceptions..." if exceptions.size == 0
            end

            def help
              ["!help - show help",
                "!all - show all exceptions",
                "!last - show last exception",
                "!last [number] - show last [number] exceptions",
                "!mostly - show the last common exception",
                "!mostly [number] - show the last [number] common exceptions"]
            end
          end

        end


        if running_eventmachine?
          @bot.start
          return @bot
        else
          thread = Thread.new do
            @bot.start
          end
          return @bot, thread
        end
      end

      def deliver(issue)
        # request.rb
      end
      
      def running_eventmachine?
        ::EM.reactor_running? rescue false
      end

      def prepare_message(exception)
        "Exception! | " + exception[:issue].exception.class.to_s + " | " + exception[:link]
      end

      def add_exception(body, issue, link, options = {})
        hash = Digest::SHA1.hexdigest(issue.backtrace.to_s + issue.exception.to_s)
        @exceptions[hash] ||= { :issue => issue, :link => link, :body => body, :counter => 0, :created_at => Time.now }
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
end
