require "test_helper"

class ImageUploaderTest < ActiveSupport::TestCase
  test "generates a dynamic thumbnail" do
    image = ImageUploader.upload(
      StringIO.new(TEST_IMAGE_DATA),
      :store,
      metadata: { "filename" => "image.png", "mime_type" => "image/png" }
    )

    thumbnail = image.derivation(:thumbnail, "50", "50").generate
    dimensions = MiniMagick::Image.open(thumbnail.path).dimensions

    assert dimensions.all? { |dimension| dimension <= 50 }
  ensure
    thumbnail&.close!
  end
end
