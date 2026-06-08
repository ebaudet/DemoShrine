require "test_helper"

class LayoutHelperTest < ActionView::TestCase
  test "detects the current controller" do
    stub(:params, { controller: "posts" }) do
      assert controller?("posts", "albums")
      assert_not controller?("home")
    end
  end

  test "returns active class for the current page" do
    stub(:current_page?, ->(path) { path == "/posts" }) do
      assert_equal "active", is_active?("/posts")
      assert_nil is_active?("/albums")
    end
  end

  test "renders markdown and source code" do
    assert_includes markdown("**bold**"), "<strong>bold</strong>"

    rendered = render_source("puts 'hello'", :ruby, "example.rb")
    assert_includes rendered, "example.rb"
    assert_includes rendered, "puts 'hello'"
  end
end
