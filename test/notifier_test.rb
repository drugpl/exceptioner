require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'xmpp4r'

class NotifierTest < Test::Unit::TestCase

  class TestException < StandardError; end

  class TestError < StandardError; end

  def setup
    Exceptioner::Notifier.stubs(:dispatch_exception).returns(true)
    config.mail.recipients = %w[michal@example.net]
    config.jabber.jabber_id = %w[jabber@example.net]
    config.jabber.password = 'secret'
    config.jabber.recipients = %w[michal@example.net]
    mail_system.clear_deliveries 
  end

  def test_deliver_exception_by_email
    exception = get_exception
    Exceptioner::Notifier.stubs(:transports).returns([:mail])
    Exceptioner::Notifier.dispatch(exception)
    assert_equal 1, mail_system.deliveries.size

  end

  def test_deliver_exception_by_jabber
    exception = get_exception
    Exceptioner::Notifier.stubs(:transports).returns([:jabber])
    Jabber::Client.any_instance.expects(:connect).once
    Jabber::Client.any_instance.expects(:auth).with(config.jabber.password).once
    Jabber::Client.any_instance.expects(:send).once
    Exceptioner::Notifier.dispatch(exception)
  end

  def test_ignores_specified_exceptions_given_by_string
    Exceptioner.ignore = %w[NotifierTest::TestException]
    exception = get_exception(TestException)
    Exceptioner::Notifier.stubs(:transports).returns([:mail])
    Exceptioner::Notifier.dispatch(exception)
    assert_equal 0, mail_system.deliveries.size
  end
  
  def test_ignores_specified_exceptions_given_by_class
    Exceptioner.ignore = NotifierTest::TestError
    exception = get_exception(TestError)
    Exceptioner::Notifier.stubs(:transports).returns([:mail])
    Exceptioner::Notifier.dispatch(exception)
    assert_equal 0, mail_system.deliveries.size
  end

end
