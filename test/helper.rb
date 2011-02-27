require 'test/unit'
require 'mocha'

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'exceptioner'
require 'rack'
require 'mock_smtp'

class ExceptionerTestCase < Test::Unit::TestCase

  attr_reader :notifier

  def setup
  end

  def notifier
    @notifier ||= Exceptioner::Notifier.new(Exceptioner::Configuration.new)
  end

  def config
    notifier.config
  end

  def transport(name)
    notifier.transport_instance(name)
  end

  def get_exception(klass = Exception)
    raise klass.new("Test Exception")
  rescue Exception => exception
    exception
  end

  def mail_system
    MockSMTP
  end

end
