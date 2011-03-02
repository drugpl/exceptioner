require 'erb'
require 'exceptioner/dispatchable'
require 'exceptioner/transport/helper'

module Exceptioner
  module Transport
    class Base
      include Exceptioner::Dispatchable

      attr_reader :config

      def initialize(config)
        @config = config
      end

      def name
        self.class.name
      end

      def deliver(issue)
        raise Exceptioner::ExceptionerError, 'Implement deliver method in your Exceptioner::Transport::Base subclass'
      end

      protected
      def default_options
        {
          :sender => config.sender || 'exceptioner',
          :recipients => config.recipients,
          :prefix => config.prefix,
          :subject => config.subject
        }
      end

      def prefixed_subject(options)
        "#{options[:prefix]}#{options[:error_message]}"
      end

      def render(issue)
        ERB.new(template, nil, '>').result(binding)
      end

      def template
        @template ||= File.read(File.expand_path(File.join(File.dirname(__FILE__), 'templates', 'exception.erb')))
      end
    end
  end
end
