require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'xmpp4r'
require 'tinder'
require 'ostruct'

class NotifierTest < ExceptionerTestCase
  class TestException < StandardError; end

  class TestError < StandardError; end

  def test_calls_deliver
    exception = get_exception(TestException)
    config.transports = [:mail]
    transport(:mail).expects(:deliver)
    notifier.dispatch(:exception => exception)
  end

  def test_ignores_specified_exceptions_given_by_string
    config.ignore = %w[NotifierTest::TestException]
    config.transports = [:mail]
    exception = get_exception(TestException)
    transport(:mail).expects(:deliver).never
    notifier.dispatch(:exception => exception)
  end

  def test_ignores_specified_exceptions_given_by_class
    config.ignore = NotifierTest::TestError
    config.transports = [:mail]
    exception = get_exception(TestError)
    transport(:mail).expects(:deliver).never
    notifier.dispatch(:exception => exception)
  end

  def test_run_global_dispatchers
    exception = get_exception(TestError)
    object = mock()
    object.expects(:do_something).with(exception)
    notifier.add_dispatcher do |exception|
      object.do_something(exception)
    end
    transport(:mail).stubs(:deliver)
    notifier.dispatch(:exception => exception)
  end

  def test_run_dispatchers_for_transport
    exception = get_exception(TestError)
    config.transports = [:jabber]
    object = mock()
    object.expects(:do_something).with(exception)
    transport(:jabber).add_dispatcher do |exception|
      object.do_something(exception)
    end
    transport(:jabber).expects(:deliver)
    notifier.dispatch(:exception => exception)
  end

  def test_breaks_if_returned_false_from_dispatcher
    exception = get_exception(TestError)
    config.transports = [:mail]
    object = mock()
    object.expects(:do_something).with(exception).returns(false)
    transport(:mail).add_dispatcher do |exception|
      object.do_something(exception)
    end
    transport(:mail).expects(:deliver).never
    notifier.dispatch(:exception => exception)
  end

  def test_transport_has_one_instance
    config.transports = [:mail]
    instance1 = notifier.transport(:mail)
    instance2 = notifier.transport(:mail)
    assert instance1.object_id == instance2.object_id
  end

  def test_transport_is_initialized
    config.transports = [:mail]
    assert transport(:mail).initialized?
  end
end
