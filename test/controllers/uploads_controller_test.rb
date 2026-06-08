require "test_helper"

class UploadsControllerTest < ActionDispatch::IntegrationTest
  test "uploads an image to cache storage" do
    file = Rack::Test::UploadedFile.new(
      Rails.root.join("public/apple-touch-icon.png"),
      "image/png"
    )

    post "/upload", params: { file: file }

    assert_response :success
    assert_equal "cache", response.parsed_body.fetch("storage")
    assert response.parsed_body.fetch("id").end_with?(".png")
  end

  test "rejects derivations without a valid signature" do
    get "/derivations/image/thumbnail/50/50/missing"

    assert_response :forbidden
  end
end
