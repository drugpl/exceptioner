require 'exceptioner/test/exceptioner_test_case'

class TransportTestCase < ExceptionerTestCase

  # Prevent test::unit (or mocha?) complaining with "no tests were defiend"
  def test_truth
    assert true
  end

  protected
  def test_config
    config 
  end

end
