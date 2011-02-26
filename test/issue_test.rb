require File.expand_path(File.dirname(__FILE__) + '/helper')


class IssueTest < Test::Unit::TestCase
  def setup
    @exception = StandardError.new('Message')
    @params = { :value => 'key' }
    @controller = stub('ActionController::Base', :params => @params, :controller_name => 'base')
    @issue = Exceptioner::Issue.new(@exception, @controller, 'production')
  end

  def test_exception_name
    assert_equal('StandardError', @issue.exception_name)
  end

  def test_backtrace
    assert_equal(@exception.backtrace, @issue.backtrace)
  end

  def test_exception
    assert_equal(@exception, @issue.exception)
  end

  def test_message
    assert_equal('Message', @issue.message)
  end

  def test_controller
    assert_equal(@controller, @issue.controller)
  end

  def test_controller_name
    assert_equal('base', @issue.controller_name)
  end

  def test_params
    assert_equal(@params, @issue.params)
  end

  def test_env
    assert_equal('production', @issue.env)
  end
end