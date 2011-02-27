require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TransportTestCase < ExceptionerTestCase
  def setup
    Exceptioner.reset_config
    config.ignore = []
    Exceptioner.reset_dispatchers
    Exceptioner.transport_instance(:mail).clear_dispatchers
    Exceptioner.transport_instance(:jabber).clear_dispatchers
    mail_system.clear_deliveries
  end
end
