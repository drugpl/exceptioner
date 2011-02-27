class ExceptionerTestCase < Test::Unit::TestCase

  def get_exception(klass = Exception)
    raise klass.new("Test Exception")
  rescue Exception => exception
    exception
  end

  def config
    Exceptioner.config
  end

end
