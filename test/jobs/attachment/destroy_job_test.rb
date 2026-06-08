require "test_helper"

class Attachment::DestroyJobTest < ActiveJob::TestCase
  test "destroys attachment from serialized data" do
    attacher = Minitest::Mock.new
    attacher.expect(:destroy, nil)

    Shrine::Attacher.stub(:from_data, attacher) do
      Attachment::DestroyJob.perform_now({ "attachment" => "data" })
    end

    assert_mock attacher
  end
end
