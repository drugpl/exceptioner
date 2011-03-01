require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'exceptioner/issue'
require 'webmock/test_unit'
require 'em-spec/test'
require 'json'

class HttpTransportTest < TransportTestCase
  include EventMachine::TestHelper

  def setup
    super
    @exception = get_exception
    @api_key = "hoptoad_rly?"
    @api_uri = "http://exceptioner.com/api/0.1/issues"
    config.transports = [:http]
    config.http.api_key = @api_key
  end

  def test_successful_deliver_exception_by_net_http
    expect_successful_request(message_params)
    notifier.dispatch(:exception => @exception)
  end

  def test_failed_deliver_exception_by_net_http
    expect_unsuccessful_request(message_params)
    assert_raise Exceptioner::Transport::Http::RequestError do
      notifier.dispatch(:exception => @exception)
    end
  end

  def test_eventmachine_reactor_running
    http = notifier.transport(:http)
    assert !http.running_eventmachine?
    em do
      assert http.running_eventmachine?
      done
    end
  end

  def test_successful_deliver_exception_by_eventmachine_http
    expect_successful_request(message_params)
    em do
      notifier.dispatch(:exception => @exception)
      EM.add_timer(0.1) { done }
    end
  end

  def test_failed_deliver_exception_by_eventmachine_http
    # XXX: em-spec is not catching exception from EM
    expect_unsuccessful_request(message_params)
    em do
      assert_raise Exceptioner::Transport::Http::RequestError do
        notifier.dispatch(:exception => @exception)
      end
      EM.add_timer(0.1) { done }
    end
  end

  def test_require_api_key_option
    config.http.api_key = nil
    assert_raise Exceptioner::Transport::Http::ConfigurationError do
      notifier.dispatch(:exception => @exception)
    end
  end

  protected
  def request_params(message_params)
    {
      :body => { :issue => message_params }.to_json,
      :headers => {
        'API-Key' => @api_key,
        'Content-Type' => 'application/json'
      }
    }
  end

  def message_params
    issue = Exceptioner::Issue.new(:exception => @exception)
    {
      :name => issue.exception_name,
      :message => issue.message,
      :backtrace => issue.formatted_backtrace
    }
  end

  def expect_successful_request(options = {})
    stub_request(:post, @api_uri).with(request_params(options))
  end

  def expect_unsuccessful_request(options = {})
    stub_request(:post, @api_uri).with(request_params(options)).to_return(:status => [500, "Internal Server Error"])
  end
end
