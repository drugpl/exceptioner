require 'test/unit'
require 'mocha'

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'exceptioner'
require 'rack'
require 'mock_smtp'
require 'mock_irc_bot'

class Test::Unit::TestCase

  def get_exception(klass = Exception)
    raise klass.new("Test Exception")
  rescue Exception => exception
    exception
  end

  def config
    Exceptioner
  end

  def mail_system
    MockSMTP
  end

end
