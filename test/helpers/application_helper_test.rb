require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "returns configured upload server" do
    assert_equal :app, upload_server
  end
end
