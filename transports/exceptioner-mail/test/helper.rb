require 'test/unit'
require 'mocha'

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'exceptioner'
require 'exceptioner-mail'
require 'mock_smtp'

class Test::Unit::TestCase

  def get_exception(klass = Exception)
    raise klass.new("Test Exception")
  rescue Exception => exception
    exception
  end

  def config
    Exceptioner.config
  end

  def mail_system
    MockSMTP
  end

end
