require File.expand_path(File.dirname(__FILE__) + '/helper')


class SetupTest < Test::Unit::TestCase

  def test_each_transport_is_initialized
    Exceptioner.config.transports = [:mail, :jabber]
    Exceptioner::Transport::Mail.any_instance.expects(:init)
    Exceptioner::Transport::Jabber.any_instance.expects(:init)
    Exceptioner.setup
  end

  def test_only_added_transports_are_initialized
    Exceptioner.config.transports = [:mail]
    Exceptioner::Transport::Jabber.any_instance.expects(:init).never
    Exceptioner.setup
  end

  def test_initialized_returns_true
    Exceptioner.config.transports = [:mail]
    Exceptioner.setup
    transport = Exceptioner.transport_instance(:mail)
    assert transport.initialized?
  end

end
