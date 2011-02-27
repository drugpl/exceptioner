require File.expand_path(File.dirname(__FILE__) + '/helper')

class UtilsTest < Test::Unit::TestCase

  def test_camelize
    assert "ExceptionerForTheWin", Exceptioner::Utils.camelize("exceptioner_for_the_win")
    assert "ExceptionerForTheWin", Exceptioner::Utils.camelize("ExceptionerForTheWin")
    assert "ExceptionerForTheWin", Exceptioner::Utils.camelize("ExceptionerFor_the_win")
  end

  def test_filter_backtrace
    backtrace = [
      "/path/to/app/file.rb:4:in `index'",
      "/path/to/gems/some/file.rb:4:in `send_action'",
      "/path/to/more/gems/other/file.rb:409:in `_run_process_action_callbacks'",
      "/leave/this/alone/path/to/app/something.rb:409:in `index'"
    ]
    expected_filtered_backtrace = [
      "APPLICATION_PATH/file.rb:4:in `index'",
      "GEM_PATH/some/file.rb:4:in `send_action'",
      "GEM_PATH/other/file.rb:409:in `_run_process_action_callbacks'",
      "/leave/this/alone/path/to/app/something.rb:409:in `index'"
    ]
    options = { :application_path => "/path/to/app", :gem_path => ["/path/to/gems", "/path/to/more/gems"] }
    assert_equal expected_filtered_backtrace, Exceptioner::Utils::filter_backtrace(backtrace, options)
  end
end
