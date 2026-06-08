require "test_helper"

class AlbumTest < ActiveSupport::TestCase
  test "requires a name and cover photo" do
    album = Album.new

    assert_not album.valid?
    assert_includes album.errors[:name], "can't be blank"
    assert_includes album.errors[:cover_photo], "can't be blank"
  end

  test "accepts nested photos" do
    album = Album.new(
      name: "Album",
      cover_photo: uploaded_image,
      photos_attributes: {
        "0" => { image: uploaded_image(filename: "photo.png") }
      }
    )

    assert album.valid?
    assert_equal 1, album.photos.length
  end

  test "destroys associated photos" do
    album = albums(:one)

    assert_difference("Photo.count", -1) do
      album.destroy!
    end
  end
end
