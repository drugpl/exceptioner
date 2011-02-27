# TODO mock_irc_bot breaks other tests (e.g. IssueTest)
# require File.expand_path(File.dirname(__FILE__) + '/mock_irc_bot')

module IrcTransportTest
  def setup
    config.irc.channel = "#example-channel"
    super if defined?(super)
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
end
