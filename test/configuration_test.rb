require File.expand_path(File.dirname(__FILE__) + '/helper')

class ConfigurationTest < ExceptionerTestCase
  def test_default_logger
    assert_equal Exceptioner.logger.class, Logger
  end
end
