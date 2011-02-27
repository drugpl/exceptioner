module MailTransportTest
  def setup
    config.mail.recipients = %w[michal@example.net]
    super if defined?(super)
  end

  def test_deliver_exception_by_email
    exception = get_exception
    config.transports = [:mail]
    ::Mail::Message.any_instance.expects(:deliver).once
    Exceptioner::Notifier.dispatch(:exception => exception)
  end
end
