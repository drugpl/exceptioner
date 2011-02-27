require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'mail'

class MailTransportTest < TransportTestCase
  def setup
    super
    notifier.config.mail.recipients = %w[michal@example.net]
  end

  def test_deliver_exception_by_email
    exception = get_exception
    notifier.config.transports = [:mail]
    ::Mail::Message.any_instance.expects(:deliver).once
    notifier.dispatch(:exception => exception)
  end
end
