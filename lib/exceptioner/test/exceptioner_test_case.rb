class ExceptionerTestCase < Test::Unit::TestCase

  attr_reader :notifier

  def setup
    @notifier = nil
  end

  # Prevent test::unit (or mocha?) complaining with "no tests were defiend"
  def test_truth
    assert true
  end

  def notifier
    @notifier ||= Exceptioner::Notifier.new(Exceptioner::Configuration.new)
  end

  def config
    notifier.config
  end

  def transport(name)
    notifier.transport(name)
  end

  def get_exception(klass = Exception)
    raise klass.new("Test Exception")
  rescue Exception => exception
    exception
  end

end
