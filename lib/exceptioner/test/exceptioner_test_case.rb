class ExceptionerTestCase < Test::Unit::TestCase

  attr_reader :notifier

  def setup
    @notifier = nil
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
