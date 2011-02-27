require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'exceptioner/transport/base'

class SetupTest < Test::Unit::TestCase

  def setup
    Exceptioner.reset_config
    @fake_mail_transport = Class.new(Exceptioner::Transport::Base).new
    @fake_jabber_transport = Class.new(Exceptioner::Transport::Base).new
    Exceptioner.stubs(:transport_instance).with(:mail).returns(@fake_mail_transport)
    Exceptioner.stubs(:transport_instance).with(:jabber).returns(@fake_jabber_transport)
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
    assert !Exceptioner.transport_instance(:jabber).initialized?
  end

end
