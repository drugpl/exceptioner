require 'exceptioner/test/exceptioner_test_case'

class TransportTestCase < ExceptionerTestCase
  def setup
    Exceptioner.reset_config
    config.ignore = []
    Exceptioner.reset_dispatchers
  end
end
