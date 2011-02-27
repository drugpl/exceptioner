require File.expand_path(File.dirname(__FILE__) + '/helper')

class UtilsTest < ExceptionerTestCase

  def test_camelize
    assert "ExceptionerForTheWin", Exceptioner::Utils.camelize("exceptioner_for_the_win")
    assert "ExceptionerForTheWin", Exceptioner::Utils.camelize("ExceptionerForTheWin")
    assert "ExceptionerForTheWin", Exceptioner::Utils.camelize("ExceptionerFor_the_win")
  end
end
