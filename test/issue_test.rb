require File.expand_path(File.dirname(__FILE__) + '/helper')


# class IssueTest < Test::Unit::TestCase
#   def setup
#     @exception = StandardError.new('Message')
#     @controller_params = { :value => 'key' }
#     @controller = stub('ActionController::Base', :params => @controller_params, :controller_name => 'base')
#     @issue = Exceptioner::Issue.new
#   end
# 
#   def test_initialization_by_exception
#     issue = Exceptioner::Issue.new(:exception => @exception)
#     assert_equal(@exception, issue.exception)
#     assert_equal(@exception.backtrace, issue.backtrace)
#     assert_equal(@exception.message, issue.message)
#   end
# 
#   def test_initialize_by_allowed_options
#     issue = Exceptioner::Issue.new(:controller => @controller, :env => 'production')
#     assert_equal(@controller, issue.controller)
#     assert_equal('production', issue.env)
#   end
# 
#   def test_initialize_unallowed_optioms
#     issue = proc { Exceptioner::Issue.new(:unallowed => 'option') }
#     assert_raise(Exceptioner::ExceptionerError, &issue)
#   end
# 
#   def test_exception_name
#     @issue.exception = @exception
#     assert_equal('StandardError', @issue.exception_name)
# 
#     @issue.exception = nil
#     assert_nil(@issue.exception_name)
#   end
# 
#   def test_backtrace
#     @issue.backtrace = 'backtrace'
#     assert_equal('backtrace', @issue.backtrace)
#   end
# 
#   def test_exception
#     @issue.exception = @exception
#     assert_equal(@exception, @issue.exception)
#   end
# 
#   def test_message
#     @issue.message = 'message'
#     assert_equal('message', @issue.message)
#   end
# 
#   def test_controller
#     @issue.controller = @controller
#     assert_equal(@controller, @issue.controller)
#   end
# 
#   def test_controller_name
#     @issue.controller = @controller
#     assert_equal('base', @issue.controller_name)
# 
#     @issue.controller = nil
#     assert_nil(@issue.controller_name)
#   end
# 
#   def test_params
#     params = { 'parameter' => 'value' }
#     @issue.controller = @controller
#     assert_equal(@controller_params, @issue.params)
# 
#     @issue.controller = nil
#     @issue.params = params
#     assert_equal(params, @issue.params)
#   end
# 
#   def test_env
#     @issue.env = 'production'
#     assert_equal('production', @issue.env)
#   end
# 
#   def test_transports
#     transports = [:mail, :irc]
#     @issue.transports = transports
#     assert_equal(transports, @issue.transports)
#   end
# end
