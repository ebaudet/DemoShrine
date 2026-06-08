require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "renders index newest first" do
    @post.update_column(:updated_at, 1.day.ago)
    posts(:two).update_column(:updated_at, Time.current)

    get posts_url

    assert_response :success
    assert_select "tbody tr:first-child td", text: posts(:two).name
  end

  test "renders new, show, and edit" do
    get new_post_url
    assert_response :success

    get post_url(@post)
    assert_response :success

    get edit_post_url(@post)
    assert_response :success
  end

  test "creates a post with success flash" do
    assert_difference("Post.count") do
      post posts_url, params: { post: { content: "Content", name: "Created" } }
    end

    assert_redirected_to post_url(Post.last)
    assert_equal "Post was successfully created.", flash[:success]
  end

  test "rejects an invalid post" do
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { name: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "updates and rejects invalid updates" do
    patch post_url(@post), params: { post: { name: "Updated" } }
    assert_redirected_to post_url(@post)
    assert_equal "Updated", @post.reload.name

    patch post_url(@post), params: { post: { name: "" } }
    assert_response :unprocessable_entity
  end

  test "destroys a post" do
    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
    assert_equal "Post was successfully destroyed.", flash[:success]
  end

  test "supports JSON CRUD and validation errors" do
    get posts_url(format: :json)
    assert_response :success
    assert_equal 2, response.parsed_body.length

    post posts_url(format: :json), params: { post: { name: "JSON", content: "Body" } }
    assert_response :created
    created = Post.find(response.parsed_body.fetch("id"))

    get post_url(created, format: :json)
    assert_response :success
    assert_equal "JSON", response.parsed_body.fetch("name")

    patch post_url(created, format: :json), params: { post: { name: "Updated JSON" } }
    assert_response :success
    assert_equal "Updated JSON", response.parsed_body.fetch("name")

    patch post_url(created, format: :json), params: { post: { name: "" } }
    assert_response :unprocessable_entity
    assert response.parsed_body.key?("name")

    delete post_url(created, format: :json)
    assert_response :no_content
  end
end
