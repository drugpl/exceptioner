require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'ostruct'

class NotifierTest < ExceptionerTestCase
  class TestException < StandardError; end

  class TestError < StandardError; end

  def test_calls_deliver
    exception = get_exception(TestException)
    config.transports = [:test]
    transport(:test).expects(:deliver)
    notifier.dispatch(:exception => exception)
  end

  def test_ignores_specified_exceptions_given_by_class
    config.ignore = NotifierTest::TestError
    config.transports = [:test]
    exception = get_exception(TestError)
    transport(:test).expects(:deliver).never
    notifier.dispatch(:exception => exception)
  end

  def test_ignores_specified_exceptions_given_by_string
    config.ignore = "NotifierTest::TestError"
    config.transports = [:test]
    exception = get_exception(TestError)
    transport(:test).expects(:deliver).never
    notifier.dispatch(:exception => exception)
  end

  def test_run_global_dispatchers
    exception = get_exception(TestError)
    config.transports = [:test]
    object = mock()
    object.expects(:do_something).with(exception)
    notifier.add_dispatcher do |exception|
      object.do_something(exception)
    end
    transport(:test).stubs(:deliver)
    notifier.dispatch(:exception => exception)
  end

  def test_run_dispatchers_for_transport
    exception = get_exception(TestError)
    config.transports = [:test]
    object = mock()
    object.expects(:do_something).with(exception)
    transport(:test).add_dispatcher do |exception|
      object.do_something(exception)
    end
    transport(:test).expects(:deliver)
    notifier.dispatch(:exception => exception)
  end

  def test_breaks_if_returned_false_from_dispatcher
    exception = get_exception(TestError)
    config.transports = [:test]
    object = mock()
    object.expects(:do_something).with(exception).returns(false)
    transport(:test).add_dispatcher do |exception|
      object.do_something(exception)
    end
    transport(:test).expects(:deliver).never
    notifier.dispatch(:exception => exception)
  end

  def test_transport_has_one_instance
    config.transports = [:test]
    instance1 = notifier.transport(:test)
    instance2 = notifier.transport(:test)
    assert instance1.object_id == instance2.object_id
  end

  def test_transport_is_initialized
    config.transports = [:test]
    assert transport(:test).initialized?
  end
end
