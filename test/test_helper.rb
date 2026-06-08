ENV['RAILS_ENV'] ||= 'test'

require "simplecov"
SimpleCov.start "rails" do
  add_filter "/app/channels/"
  add_filter "/app/mailers/"
  add_filter "/app/jobs/application_job.rb"
end

require_relative "../config/environment"
require "rails/test_help"
require "base64"
require "minitest/mock"
require "stringio"

class ActiveSupport::TestCase
  TEST_IMAGE_DATA = Base64.decode64(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
  ).freeze

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def uploaded_image(filename: "image.png", mime_type: "image/png")
    source = StringIO.new(TEST_IMAGE_DATA)

    ImageUploader.upload(
      source,
      :cache,
      metadata: {
        "filename" => filename,
        "mime_type" => mime_type,
        "size" => source.size,
        "width" => 1,
        "height" => 1
      }
    )
  end

  def uploaded_image_data(**options)
    uploaded_image(**options).to_json
  end
end
