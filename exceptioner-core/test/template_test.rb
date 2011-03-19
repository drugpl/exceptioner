require File.expand_path(File.dirname(__FILE__) + '/helper')


class TemplateTest < ExceptionerTestCase

  def setup
    @exception = get_exception
    @controller_params = { :value => 'key' }
    @env = { :ruby => '1.9.2', :shell => 'bash' }
    @controller = stub('ActionController::Base', :params => @controller_params, :controller_name => 'base', :action_name => 'test_action')
    @issue = Exceptioner::Issue.new(:controller => @controller, :exception => @exception, :env => @env)
    @transport = Exceptioner::Transport::Testing.new
  end

  def test_renders
    assert_nothing_raised { @transport.render(@issue) }
  end

  def test_render_controller_name
    assert_match @issue.controller.controller_name, @transport.render(@issue)
  end

  def test_render_controller_action_name
    assert_match @issue.controller.action_name, @transport.render(@issue)
  end

  def test_render_exception_message
   assert_match @issue.exception.message, @transport.render(@issue)
  end

  def test_render_exception_class
    assert_match @issue.exception.class.name, @transport.render(@issue)
  end

  def test_render_backtrace
    assert_match @issue.formatted_backtrace, @transport.render(@issue)
  end

  def test_render_params
    render = @transport.render(@issue)
    @issue.params.each_pair do |k,v|
      assert_match k.to_s, render
      assert_match v.to_s, render
    end
  end

  def test_render_params
    render = @transport.render(@issue)
    @issue.env.each_pair do |k,v|
      assert_match k.to_s, render
      assert_match v.to_s, render
    end
  end

end
