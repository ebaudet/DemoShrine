require "test_helper"

class PhotoTest < ActiveSupport::TestCase
  test "belongs to an album" do
    assert_equal albums(:one), photos(:one).album
  end

  test "requires an album and image" do
    photo = Photo.new

    assert_not photo.valid?
    assert_includes photo.errors[:album], "must exist"
    assert_includes photo.errors[:image], "can't be blank"
  end
end
