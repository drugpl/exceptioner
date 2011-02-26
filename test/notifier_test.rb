require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'xmpp4r'
require 'tinder'
require 'ostruct'

class NotifierTest < Test::Unit::TestCase

  class TestException < StandardError; end

  class TestError < StandardError; end

  def setup
    config.mail.recipients = %w[michal@example.net]
    config.jabber.jabber_id = %w[jabber@example.net]
    config.jabber.password = 'secret'
    config.jabber.recipients = %w[michal@example.net]
    config.ignore = []
    config.reset_dispatchers
    config.mail.clear_dispatchers
    config.jabber.clear_dispatchers
    config.campfire.subdomain = 'example'
    config.campfire.username = 'lukasz'
    config.campfire.token = 'randomtoken'
    config.irc.channel = "#example-channel"
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

  def test_deliver_exception_by_irc
    @socket, @server = MockSocket.pipe

    TCPSocket.stubs(:open).with(anything, anything).returns(@socket)
    stub(Exceptioner::Transport::Irc).post_body(anything) {'http://example.link.com/'}

    exception = get_exception
    Exceptioner::Notifier.stubs(:transports).returns([:irc])
    Exceptioner::Transport::Irc.configure
    Exceptioner::Transport::Irc.bot.configure do |config|
      config.environment = :test
    end

    Isaac::Bot.any_instance.expects(:msg).with(any_parameters).once do |channel, message|
      assert_equal message, "Exception!: http://example.link.com/"
      assert_equal channel, "#example-channel"
    end

    Exceptioner::Notifier.dispatch(exception)
  end

  def test_jabber_registration
    Exceptioner::Notifier.stubs(:transports).returns([:jabber])
    Jabber::Client.any_instance.expects(:connect).once
    Jabber::Client.any_instance.expects(:register).with(config.jabber.password).once
    Exceptioner::Transport::Jabber.register
  end

  def test_jabber_subscription
    Exceptioner::Notifier.stubs(:transports).returns([:jabber])
    Jabber::Client.any_instance.expects(:connect).once
    Jabber::Client.any_instance.expects(:auth).with(config.jabber.password).once
    Jabber::Client.any_instance.expects(:send).
      with() { |v| v.to_s.match "<presence" }.
      times(config.jabber.recipients.length)
    Exceptioner::Transport::Jabber.subscribe
  end

  def test_deliver_exception_by_campfire
    exception = get_exception
    Exceptioner::Notifier.stubs(:transports).returns([:campfire])
    Exceptioner::Transport::Campfire.stubs(:rooms).returns(['test'])
    room_mock = stub_everything('Tinder::Room', :id => 1, :name => 'test')
    room_mock.expects(:paste)
    Tinder::Campfire.any_instance.stubs(:rooms).returns([room_mock])
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
  
  def test_run_global_dispatch
    exception = get_exception(TestError)
    object = mock()
    object.expects(:do_something).with(exception)
    Exceptioner.config.dispatch do |exception|
      object.do_something(exception)
    end
    Exceptioner::Notifier.dispatch(exception)
  end

  def test_run_dispatch_for_transport
    exception = get_exception(TestError)
    Exceptioner::Notifier.stubs(:transports).returns([:jabber])
    Exceptioner::Transport::Jabber.stubs(:deliver)
    object = mock()
    object.expects(:do_something).with(exception)
    Exceptioner.config.jabber.dispatch do |exception|
      object.do_something(exception)
    end
    Exceptioner::Notifier.dispatch(exception)
  end

  def test_breaks_if_returned_false_from_dispatch
    exception = get_exception(TestError)
    Exceptioner::Notifier.stubs(:transports).returns([:mail])
    object = mock()
    object.expects(:do_something).with(exception).returns(false)
    Exceptioner.config.mail.dispatch do |exception|
      object.do_something(exception)
    end
    Exceptioner::Notifier.dispatch(exception)
  end
  

end
