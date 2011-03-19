require File.expand_path(File.dirname(__FILE__) + '/helper')

class FormatterTest < ExceptionerTestCase
  class TestError < StandardError; end

  def test_renders_only_configured_partials
    config.transports = [:testing]
    transport = notifier.transport(:testing)
    issue = Exceptioner::Issue.new(:exception => get_exception(TestError))

    transport.config.template = [:exception, :backtrace]
    body = transport.render(issue)
    assert body.match("Application raised")
    assert body.match("exceptioner_test_case.rb:27")

    transport.config.template = [:backtrace]
    body = notifier.transport(:testing).render(issue)
    assert ! body.match("Application raised")
    assert body.match("exceptioner_test_case.rb:27")
  end
end
