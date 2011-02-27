require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TransportTestCase < ExceptionerTestCase
  def setup
    Exceptioner.reset_config
    config.ignore = []
    Exceptioner.reset_dispatchers
  end
end
