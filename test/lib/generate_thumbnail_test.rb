require "test_helper"

class GenerateThumbnailTest < ActiveSupport::TestCase
  test "resizes an image to fit within the requested dimensions" do
    source = Tempfile.new(["source", ".png"])
    source.binmode
    source.write(TEST_IMAGE_DATA)
    source.rewind

    thumbnail = GenerateThumbnail.call(source, 50, 50)
    image = MiniMagick::Image.open(thumbnail.path)

    assert_operator image.width, :<=, 50
    assert_operator image.height, :<=, 50
  ensure
    source&.close!
    thumbnail&.close!
  end
end
