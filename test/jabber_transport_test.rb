module JabberTransportTest
  def setup
    config.jabber.jabber_id = %w[jabber@example.net]
    config.jabber.password = 'secret'
    config.jabber.recipients = %w[michal@example.net]
    super if defined?(super)
  end

  def test_deliver_exception_by_jabber
    exception = get_exception
    Exceptioner::Notifier.stubs(:transports).returns([:jabber])
    Jabber::Client.any_instance.expects(:connect).once
    Jabber::Client.any_instance.expects(:auth).with(config.jabber.password).once
    Jabber::Client.any_instance.expects(:send).once
    Exceptioner::Notifier.dispatch(:exception => exception)
  end

  def test_jabber_registration
    Exceptioner::Notifier.stubs(:transports).returns([:jabber])
    Jabber::Client.any_instance.expects(:connect).once
    Jabber::Client.any_instance.expects(:register).with(config.jabber.password).once
    Exceptioner::Notifier.transport_instance(:jabber).register
  end

  def test_connecting_for_jabber_subscription
    config.transports = [:jabber]
    transport = Exceptioner.transport_instance(:jabber)
    transport.expects(:connect).once
    Exceptioner::Notifier.transport_instance(:jabber).subscribe
  end

  def test_authenticating_for_jabber_subscription
    config.transports = [:jabber]
    transport = Exceptioner.transport_instance(:jabber)
    Jabber::Client.any_instance.expects(:connect).once
    Jabber::Client.any_instance.expects(:auth).with(config.jabber.password).once
    Jabber::Client.any_instance.expects(:send).
      with() { |v| v.to_s.match "<presence" }.
      times(config.jabber.recipients.length)
    Exceptioner::Notifier.transport_instance(:jabber).subscribe
  end
end
