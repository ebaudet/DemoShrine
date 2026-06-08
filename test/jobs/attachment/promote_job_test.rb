require "test_helper"

class Attachment::PromoteJobTest < ActiveJob::TestCase
  test "creates album derivatives and promotes attachment" do
    attacher = Minitest::Mock.new
    attacher.expect(:create_derivatives, nil)
    attacher.expect(:atomic_promote, nil)

    Shrine::Attacher.stub(:retrieve, attacher) do
      Attachment::PromoteJob.perform_now(albums(:one), "cover_photo", { "id" => "cover" })
    end

    assert_mock attacher
  end

  test "promotes non-album attachment without derivatives" do
    attacher = Minitest::Mock.new
    attacher.expect(:atomic_promote, nil)

    Shrine::Attacher.stub(:retrieve, attacher) do
      Attachment::PromoteJob.perform_now(posts(:one), "image", { "id" => "image" })
    end

    assert_mock attacher
  end

  test "ignores attachments that changed" do
    Shrine::Attacher.stub(:retrieve, ->(*) { raise Shrine::AttachmentChanged }) do
      assert_nothing_raised do
        Attachment::PromoteJob.perform_now(posts(:one), "image", { "id" => "image" })
      end
    end
  end
end
