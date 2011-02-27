require File.expand_path(File.dirname(__FILE__) + '/helper')

class CampfireTransportTest < TransportTestCase
  def setup
    super
    config.campfire.subdomain = 'example'
    config.campfire.username = 'lukasz'
    config.campfire.token = 'randomtoken'
  end

  def test_deliver_exception_by_campfire
    exception = get_exception
    config.transports = [:campfire]
    config.campfire.rooms = %w[test]
    room_mock = stub_everything('Tinder::Room', :id => 1, :name => 'test')
    room_mock.expects(:paste)
    Tinder::Campfire.any_instance.stubs(:rooms).returns([room_mock])
    Exceptioner::Notifier.dispatch(:exception => exception)
  end
end
