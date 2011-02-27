require File.expand_path(File.dirname(__FILE__) + '/helper')

class MailTransportTest < TransportTestCase
  def setup
    super
    config.mail.recipients = %w[michal@example.net]
  end

  def test_deliver_exception_by_email
    exception = get_exception
    config.transports = [:mail]
    ::Mail::Message.any_instance.expects(:deliver).once
    Exceptioner::Notifier.dispatch(:exception => exception)
  end
end
