require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'mail'

class MailTransportTest < TransportTestCase
  def setup
    super
    config.transports = [:mail]
    config.mail.recipients = %w[michal@example.net]
  end

  def test_deliver_exception_by_email
    exception = get_exception
    ::Mail::Message.any_instance.expects(:deliver).once
    notifier.dispatch(:exception => exception)
  end
end
