require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'xmpp4r'
require 'tinder'
require 'ostruct'

require File.expand_path(File.dirname(__FILE__) + '/transport/mail_transport_test')
require File.expand_path(File.dirname(__FILE__) + '/transport/http_transport_test')
require File.expand_path(File.dirname(__FILE__) + '/transport/jabber_transport_test')
require File.expand_path(File.dirname(__FILE__) + '/transport/campfire_transport_test')
require File.expand_path(File.dirname(__FILE__) + '/transport/irc_transport_test')

class NotifierTest < ExceptionerTestCase
  include MailTransportTest
  include HttpTransportTest
  include JabberTransportTest
  include CampfireTransportTest
  include IrcTransportTest

  class TestException < StandardError; end

  class TestError < StandardError; end

  def setup
    Exceptioner.reset_config
    super
    config.ignore = []
    Exceptioner.reset_dispatchers
    Exceptioner.transport_instance(:mail).clear_dispatchers
    Exceptioner.transport_instance(:jabber).clear_dispatchers
    mail_system.clear_deliveries
  end

  def test_ignores_specified_exceptions_given_by_string
    config.ignore = %w[NotifierTest::TestException]
    exception = get_exception(TestException)
    Exceptioner::Notifier.stubs(:transports).returns([:mail])
    Exceptioner::Notifier.dispatch(:exception => exception)
    assert_equal 0, mail_system.deliveries.size
  end

  def test_ignores_specified_exceptions_given_by_class
    config.ignore = NotifierTest::TestError
    config.transports = [:mail]
    exception = get_exception(TestError)
    Exceptioner::Notifier.dispatch(:exception => exception)
    assert_equal 0, mail_system.deliveries.size
  end

  def test_run_global_dispatch
    exception = get_exception(TestError)
    object = mock()
    object.expects(:do_something).with(exception)
    config.dispatch do |exception|
      object.do_something(exception)
    end
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
    Exceptioner::Notifier.dispatch(:exception => exception)
    assert_equal 0, mail_system.deliveries.size
  end

  def test_transport_has_one_instance
    config.transports = [:mail]
    instance1 = Exceptioner.transport_instance(:mail)
    instance2 = Exceptioner.transport_instance(:mail)
    assert instance1.object_id == instance2.object_id
  end
end
