require File.expand_path(File.dirname(__FILE__) + '/helper')

class RackTest < ExceptionerTestCase
  def setup
    Exceptioner.destroy
  end

  def notifier
    Exceptioner.notifier
  end
    
  def test_should_dispatch_exception
    exception = get_exception
    app = lambda { |env| raise exception  }
    environment = { 'key' => 'value' }

    notifier.expects(:dispatch).with(has_entries(:env => environment, :exception => exception))
    
    begin
      stack = Exceptioner::Middleware.new(app)
      stack.call(environment)
    rescue Exception => raised
      assert_equal exception, raised
    else
      flunk "Didn't raise an exception"
    end

  end

  def test_should_assign_exception_to_rack_exception
    exception = get_exception
    response = [200, {}, ['hello world']]
    environment = { 'key' => 'value' }
    app = lambda do |env| 
      env['rack.exception'] = exception
      response
    end

    notifier.expects(:dispatch).with(has_entries(:env => environment, :exception => exception))

    stack = Exceptioner::Middleware.new(app)

    actual_response = stack.call(environment)
    assert_equal response, actual_response
  end

end
