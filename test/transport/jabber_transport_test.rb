require File.expand_path(File.dirname(__FILE__) + '/helper')

class JabberTransportTest < TransportTestCase
  def setup
    super
    config.transports = [:jabber]
    config.jabber.jabber_id = %w[jabber@example.net]
    config.jabber.password = 'secret'
    config.jabber.recipients = %w[michal@example.net]
  end

  def transport
    notifier.transport_instance(:jabber)
  end

  def test_deliver_exception_by_jabber
    exception = get_exception
    Jabber::Client.any_instance.expects(:connect).once
    Jabber::Client.any_instance.expects(:auth).with(config.jabber.password).once
    Jabber::Client.any_instance.expects(:send).once
    notifier.dispatch(:exception => exception)
  end

  def test_jabber_registration
    Jabber::Client.any_instance.expects(:connect).once
    Jabber::Client.any_instance.expects(:register).with(config.jabber.password).once
    transport.register
  end

  def test_connecting_for_jabber_subscription
    transport.expects(:connect).once
    transport.subscribe
  end

  def test_authenticating_for_jabber_subscription
    Jabber::Client.any_instance.expects(:connect).once
    Jabber::Client.any_instance.expects(:auth).with(config.jabber.password).once
    Jabber::Client.any_instance.expects(:send).
      with() { |v| v.to_s.match "<presence" }.
      times(config.jabber.recipients.length)
    transport.subscribe
  end
end
