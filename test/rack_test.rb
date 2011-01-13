require File.expand_path(File.dirname(__FILE__) + '/helper')

class RackTest < Test::Unit::TestCase
    
  def test_should_dispatch_exception
    exception = get_exception
    app = lambda { |env| raise exception  }
    environment = { 'key' => 'value' }

    Exceptioner::Notifier.expects(:dispatch).with(exception, has_entry(:env, environment))
    
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

    Exceptioner::Notifier.expects(:dispatch).with(exception, has_entry(:env, environment))

    stack = Exceptioner::Middleware.new(app)

    actual_response = stack.call(environment)
    assert_equal response, actual_response
  end

end
