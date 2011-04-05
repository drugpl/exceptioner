require 'erb'
require 'exceptioner/formatter/helper'

module Exceptioner
  class Formatter
    def initialize(partials = [])
      @partials = partials
    end

    def render(issue)
      @partials.map { |partial_name| render_partial(partial_name, issue) }.join "\n"
    end

    def render_partial(partial_name, issue)
      template = Template.new(load_template_string partial_name)
      template.issue = issue
      template.render
    end

    private

    def load_template_string(name)
      file_path = File.expand_path(File.join(File.dirname(__FILE__), 'formatter', 'templates', "#{name}.erb"))
      File.read(file_path)
    end

    class Template
      include Exceptioner::Formatter::Helper

      attr_accessor :issue

      def initialize(erb_template)
        @erb_template = erb_template
      end

      def render
        ERB.new(@erb_template, nil, '>').result(binding)
      end
    end
  end
end
