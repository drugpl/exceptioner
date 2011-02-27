require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'xmpp4r'
require 'tinder'
require 'ostruct'

class NotifierTest < ExceptionerTestCase
  class TestException < StandardError; end

  class TestError < StandardError; end

  attr_reader :notifier

  def setup
    config = Exceptioner::Configuration.new
    @notifier = Exceptioner::Notifier.new(config)
  end

  def test_calls_deliver
    exception = get_exception(TestException)
    notifier.stubs(:transports).returns([:mail])
    notifier.transport_instance(:mail).expects(:deliver)
    notifier.dispatch(:exception => exception)
  end

  def test_ignores_specified_exceptions_given_by_string
    notifier.config.ignore = %w[NotifierTest::TestException]
    exception = get_exception(TestException)
    notifier.stubs(:transports).returns([:mail])
    notifier.transport_instance(:mail).expects(:deliver).never
    notifier.dispatch(:exception => exception)
  end

  def test_ignores_specified_exceptions_given_by_class
    notifier.config.ignore = NotifierTest::TestError
    notifier.config.transports = [:mail]
    exception = get_exception(TestError)
    notifier.transport_instance(:mail).expects(:deliver).never
    notifier.dispatch(:exception => exception)
  end

  def test_run_global_dispatchers
    exception = get_exception(TestError)
    object = mock()
    object.expects(:do_something).with(exception)
    notifier.add_dispatcher do |exception|
      object.do_something(exception)
    end
    notifier.transport_instance(:mail).stubs(:deliver)
    notifier.dispatch(:exception => exception)
  end

  def test_run_dispatchers_for_transport
    exception = get_exception(TestError)
    notifier.config.transports = [:jabber]
    notifier.transport_instance(:jabber).expects(:deliver)
    object = mock()
    object.expects(:do_something).with(exception)
    notifier.transport_instance(:jabber).add_dispatcher do |exception|
      object.do_something(exception)
    end
    notifier.dispatch(:exception => exception)
  end

  def test_breaks_if_returned_false_from_dispatcher
    exception = get_exception(TestError)
    notifier.config.transports = [:mail]
    object = mock()
    object.expects(:do_something).with(exception).returns(false)
    notifier.transport_instance(:mail).add_dispatcher do |exception|
      object.do_something(exception)
    end
    notifier.transport_instance(:mail).expects(:deliver).never
    notifier.dispatch(:exception => exception)
  end

  def test_transport_has_one_instance
    notifier.config.transports = [:mail]
    instance1 = notifier.transport_instance(:mail)
    instance2 = notifier.transport_instance(:mail)
    assert instance1.object_id == instance2.object_id
  end
end
