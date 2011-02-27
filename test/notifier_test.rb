require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'tinder'
require 'ostruct'

class NotifierTest < ExceptionerTestCase
  class TestException < StandardError; end

  class TestError < StandardError; end

  def setup
    Exceptioner.reset_config
    config.ignore = []
    Exceptioner.reset_dispatchers
    Exceptioner.transport_instance(:test).clear_dispatchers
  end

  def test_ignores_specified_exceptions_given_by_string
    config.ignore = %w[NotifierTest::TestException]
    config.transports = [:test]
    Exceptioner.init
    exception = get_exception(TestException)
    Exceptioner.transport_instance(:test).expects(:deliver).never
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_ignores_specified_exceptions_given_by_class
    exception = NotifierTest::TestError
    config.ignore = [exception]
    config.transports = [:test]
    Exceptioner.init
    Exceptioner.transport_instance(:test).expects(:deliver).never
    Exceptioner::Notifier.dispatch(:exception => exception.new)
  end

  def test_run_global_dispatch
    exception = get_exception(TestError)
    config.transports = [:test]
    object = mock()
    object.expects(:do_something).with(exception)
    Exceptioner.dispatch do |exception|
      object.do_something(exception)
    end
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_run_dispatch_for_transport
    exception = get_exception(TestError)
    config.transports = [:test]
    Exceptioner.transport_instance(:test).expects(:deliver)
    object = mock()
    object.expects(:do_something).with(exception)
    Exceptioner.transport_instance(:test).dispatch do |exception|
      object.do_something(exception)
    end
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_breaks_if_returned_false_from_dispatch
    exception = get_exception(TestError)
    config.transports = [:test]
    object = mock()
    object.expects(:do_something).with(exception).returns(false)
    Exceptioner.transport_instance(:test).dispatch do |exception|
      object.do_something(exception)
    end
    Exceptioner.transport_instance(:test).expects(:deliver).never
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_transport_has_one_instance
    config.transports = [:test]
    instance1 = Exceptioner.transport_instance(:test)
    instance2 = Exceptioner.transport_instance(:test)
    assert instance1.object_id == instance2.object_id
  end
end
