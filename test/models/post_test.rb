require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "requires a name" do
    post = Post.new

    assert_not post.valid?
    assert_includes post.errors[:name], "can't be blank"
  end

  test "accepts a valid image" do
    post = Post.new(name: "Post", image: uploaded_image)

    assert post.valid?
    assert_equal "image.png", post.image.original_filename
  end

  test "rejects an unsupported image extension" do
    post = Post.new(name: "Post", image: uploaded_image(filename: "image.txt", mime_type: "text/plain"))

    assert_not post.valid?
    assert_includes post.errors[:image], "extension must be one of: jpg, jpeg, png, webp, gif"
  end
end
