require File.expand_path(File.dirname(__FILE__) + '/helper')

class RedmineTransportTest < TransportTestCase
  def setup
    super
    config.transports = [:redmine]
    config.redmine.connection do
      self.site      = 'http://your.redmine.com'
      self.user      = 'user' # or api key
      self.password  = 'pass'
    end
    config.redmine.project = 'project_id_or_identifier'
  end

  def test_deliver_exception_by_redmine
    exception = get_exception
    RedmineClient::Issue.any_instance.stubs(:save).returns(true)
    notifier.dispatch(:exception => exception)
  end
end
