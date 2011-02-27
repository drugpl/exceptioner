require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'xmpp4r'
require 'tinder'
require 'ostruct'

class NotifierTest < ExceptionerTestCase
  class TestException < StandardError; end

  class TestError < StandardError; end

  def setup
    Exceptioner.reset_config
    config.ignore = []
    Exceptioner.reset_dispatchers
  end

  def test_ignores_specified_exceptions_given_by_string
    config.ignore = %w[NotifierTest::TestException]
    exception = get_exception(TestException)
    Exceptioner::Notifier.stubs(:transports).returns([:mail])
    Exceptioner.transport_instance(:mail).expects(:deliver).never
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_ignores_specified_exceptions_given_by_class
    config.ignore = NotifierTest::TestError
    config.transports = [:mail]
    exception = get_exception(TestError)
    Exceptioner.transport_instance(:mail).expects(:deliver).never
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_run_global_dispatch
    exception = get_exception(TestError)
    object = mock()
    object.expects(:do_something).with(exception)
    Exceptioner.dispatch do |exception|
      object.do_something(exception)
    end
    Exceptioner.transport_instance(:mail).stubs(:deliver)
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_run_dispatch_for_transport
    exception = get_exception(TestError)
    config.transports = [:jabber]
    Exceptioner.transport_instance(:jabber).expects(:deliver)
    object = mock()
    object.expects(:do_something).with(exception)
    Exceptioner.transport_instance(:jabber).dispatch do |exception|
      object.do_something(exception)
    end
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_breaks_if_returned_false_from_dispatch
    exception = get_exception(TestError)
    config.transports = [:mail]
    object = mock()
    object.expects(:do_something).with(exception).returns(false)
    Exceptioner.transport_instance(:mail).dispatch do |exception|
      object.do_something(exception)
    end
    Exceptioner.transport_instance(:mail).expects(:deliver).never
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_transport_has_one_instance
    config.transports = [:mail]
    instance1 = Exceptioner.transport_instance(:mail)
    instance2 = Exceptioner.transport_instance(:mail)
    assert instance1.object_id == instance2.object_id
  end
end
