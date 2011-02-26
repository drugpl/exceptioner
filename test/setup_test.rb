require File.expand_path(File.dirname(__FILE__) + '/helper')

class SetupTest < Test::Unit::TestCase

  def setup
    Exceptioner.reset_config
  end

  def test_each_transport_is_initialized
    config.transports = [:mail, :jabber]
    Exceptioner.setup
    assert Exceptioner.transport_instance(:mail).initialized?
    assert Exceptioner.transport_instance(:jabber).initialized?
  end

  def test_only_added_transports_are_initialized
    config.transports = [:mail]
    Exceptioner.setup
    assert Exceptioner.transport_instance(:jabber).initialized?
  end

end
