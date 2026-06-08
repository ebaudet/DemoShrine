require "test_helper"

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @album = albums(:one)
  end

  test "renders index, new, show, and edit" do
    get albums_url
    assert_response :success

    get new_album_url
    assert_response :success

    get album_url(@album)
    assert_response :success

    get edit_album_url(@album)
    assert_response :success
  end

  test "creates an album with a cover photo" do
    assert_difference("Album.count") do
      post albums_url, params: { album: { name: "Created", cover_photo: uploaded_image_data } }
    end

    assert_redirected_to album_url(Album.last)
    assert_equal "Album was successfully created.", flash[:success]
  end

  test "rejects an invalid album" do
    assert_no_difference("Album.count") do
      post albums_url, params: { album: { name: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "updates album and nested photos" do
    assert_difference("Photo.count") do
      patch album_url(@album), params: {
        album: {
          name: "Updated",
          photos_attributes: {
            "new-photo" => { image: uploaded_image_data(filename: "photo.png") }
          }
        }
      }
    end

    assert_redirected_to album_url(@album)
    assert_equal "Updated", @album.reload.name
  end

  test "rejects an invalid update" do
    patch album_url(@album), params: { album: { name: "" } }

    assert_response :unprocessable_entity
  end

  test "destroys album and its photos" do
    assert_difference("Album.count", -1) do
      assert_difference("Photo.count", -1) do
        delete album_url(@album)
      end
    end

    assert_redirected_to albums_url
  end

  test "supports JSON CRUD and validation errors" do
    get albums_url(format: :json)
    assert_response :success
    assert_equal album_url(@album, format: :json), response.parsed_body.first.fetch("url")

    post albums_url(format: :json), params: {
      album: { name: "JSON", cover_photo: uploaded_image_data }
    }
    assert_response :created
    created = Album.find(response.parsed_body.fetch("id"))

    get album_url(created, format: :json)
    assert_response :success
    assert_equal "JSON", response.parsed_body.fetch("name")

    patch album_url(created, format: :json), params: { album: { name: "Updated JSON" } }
    assert_response :success

    patch album_url(created, format: :json), params: { album: { name: "" } }
    assert_response :unprocessable_entity
    assert response.parsed_body.key?("name")

    delete album_url(created, format: :json)
    assert_response :no_content
  end
end
