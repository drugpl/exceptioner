require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'xmpp4r'
require 'tinder'
require 'ostruct'

# http transport test module
require File.expand_path(File.dirname(__FILE__) + '/http_test')

require File.expand_path(File.dirname(__FILE__) + '/jabber_transport_test')

class NotifierTest < Test::Unit::TestCase
  include HttpTransportTest
  include JabberTransportTest

  class TestException < StandardError; end

  class TestError < StandardError; end

  def setup
    Exceptioner.reset_config
    super
    config.mail.recipients = %w[michal@example.net]
    config.ignore = []
    Exceptioner.reset_dispatchers
    Exceptioner.transport_instance(:mail).clear_dispatchers
    Exceptioner.transport_instance(:jabber).clear_dispatchers
    config.campfire.subdomain = 'example'
    config.campfire.username = 'lukasz'
    config.campfire.token = 'randomtoken'
    config.irc.channel = "#example-channel"
    mail_system.clear_deliveries
  end

  def test_deliver_exception_by_email
    exception = get_exception
    config.transports = [:mail]
    ::Mail::Message.any_instance.expects(:deliver).once
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  # def test_deliver_exception_by_irc
  #   @socket, @server = MockSocket.pipe
  #   TCPSocket.stubs(:open).with(anything, anything).returns(@socket)
  #
  #   exception = get_exception
  #   Exceptioner::Notifier.stubs(:transports).returns([:irc])
  #   transport = Exceptioner.transport_instance(:irc)
  #   transport.stubs(:post_body).returns('http://example.link.com/')
  #   transport.configure
  #   transport.bot.configure do |config|
  #     config.environment = :test
  #   end
  #
  #   Isaac::Bot.any_instance.expects(:msg).with(any_parameters).once do |channel, message|
  #     assert_equal message, "Exception!: http://example.link.com/"
  #     assert_equal channel, "#example-channel"
  #   end
  #
  #   Exceptioner::Notifier.dispatch(exception)
  # end

  def test_deliver_exception_by_campfire
    exception = get_exception
    config.transports = [:campfire]
    config.campfire.rooms = %w[test]
    room_mock = stub_everything('Tinder::Room', :id => 1, :name => 'test')
    room_mock.expects(:paste)
    Tinder::Campfire.any_instance.stubs(:rooms).returns([room_mock])
    Exceptioner::Notifier.dispatch(:exception => exception)
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
