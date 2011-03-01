require File.expand_path(File.dirname(__FILE__) + '/helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_irc_bot')

class IrcTransportTest < TransportTestCase
  def setup
    super
    config.transports = [:irc]
    config.irc.channel = "#example-channel"
  end

  def transport
    notifier.transport(:irc)
  end

  def test_deliver_exception_by_irc
    @socket, @server = MockSocket.pipe
    TCPSocket.stubs(:open).with(anything, anything).returns(@socket)

    exception = get_exception
    transport.stubs(:post_body).returns('http://example.link.com/')
    transport.bot.configure do |config|
      config.environment = :test
    end

    Isaac::Bot.any_instance.expects(:msg).with(any_parameters).once do |channel, message|
      assert_equal message, "Exception!: http://example.link.com/"
      assert_equal channel, "#example-channel"
    end

    notifier.dispatch(:exception => exception)
  end
end
