require 'exceptioner/dispatchable'
require 'exceptioner/formatter'

module Exceptioner
  module Transport
    class Base
      include Exceptioner::Dispatchable

      def init
      end

      def config
        @config ||= begin
                      local_config.update_attributes(@global_config.only(local_config.attributes.keys))
                      local_config
                    end
      end

      def config_name
        self.class.name.split('::').last.downcase
      end

      def local_config
        @global_config.send(self.config_name)
      end

      def configure(config)
        @global_config = config
        init unless initialized?
        @initialized = true
      end

      def initialized?
        @initialized
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
        formatter = Exceptioner::Formatter.new(config.template)
        formatter.render issue
      end
    end
  end
end
