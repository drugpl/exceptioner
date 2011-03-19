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
      ERB.new(template(partial_name), nil, '>').result(binding)
    end

    private

    def template(name)
      file_path = File.expand_path(File.join(File.dirname(__FILE__), 'formatter', 'templates', "#{name}.erb"))
      File.read(file_path)
    end
  end
end
