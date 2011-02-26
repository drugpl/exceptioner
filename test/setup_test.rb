require File.expand_path(File.dirname(__FILE__) + '/helper')


class SetupTest < Test::Unit::TestCase

  def setup
    Exceptioner.reset_config
  end

  def test_each_transport_is_initialized
    config.transports = [:mail, :jabber]
    Exceptioner::Transport::Mail.expects(:init)
    Exceptioner::Transport::Jabber.expects(:init)
    Exceptioner.setup
  end

  def test_only_added_transports_are_initialized
    Exceptioner.config.transports = [:mail]
    Exceptioner::Transport::Jabber.expects(:init).never
    Exceptioner.setup
  end

  def test_initialized_returns_true
    Exceptioner.config.transports = [:mail]
    Exceptioner.setup
    assert Exceptioner::Transport::Mail.initialized?
  end

end
