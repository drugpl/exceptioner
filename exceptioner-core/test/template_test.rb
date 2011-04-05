require File.expand_path(File.dirname(__FILE__) + '/helper')


class TemplateTest < ExceptionerTestCase

  def setup
    @exception = get_exception
    @controller_params = { :value => 'key' }
    @env = { 'ruby' => '1.9.2', 'shell' => 'bash' }
    @controller = stub('ActionController::Base', :params => @controller_params, :controller_name => 'base', :action_name => 'test_action')
    @issue = Exceptioner::Issue.new(:controller => @controller, :exception => @exception, :env => @env)
    @formatter = Exceptioner::Formatter.new([:backtrace, :env, :exception, :message, :params])
  end

  def test_renders_everything
    assert_nothing_raised { @formatter.render(@issue) }
  end

  def test_renders_template_backtrace
    body = @formatter.render_partial(:backtrace, @issue)
    assert_match @issue.formatted_backtrace, body
  end

  def test_renders_template_env
    body = @formatter.render_partial(:env, @issue)

    @issue.env.each_pair do |k,v|
      assert_match k.to_s, body
      assert_match v.to_s, body
    end
  end

  def test_renders_template_exception
    body = @formatter.render_partial(:exception, @issue)

    assert_match @issue.controller.controller_name, body
    assert_match @issue.controller.action_name, body
    assert_match @issue.exception.message, body
    assert_match @issue.exception.class.name, body
  end

  def test_renders_template_message
    body = @formatter.render_partial(:message, @issue)
    assert_match @issue.message, body
  end

  def test_renders_template_params
    body = @formatter.render_partial(:params, @issue)

    @issue.params.each_pair do |k,v|
      assert_match k.to_s, body
      assert_match v.to_s, body
    end
  end
end
