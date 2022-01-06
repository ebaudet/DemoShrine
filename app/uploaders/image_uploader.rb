# frozen_string_literal: true
class ImageUploader < Shrine
  ALLOWED_EXTENSION = %w[jpg jpeg png webp gif].freeze
  ALLOWED_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  MAX_SIZE = 10.megabytes # 10 MB
  MAX_DIMENSIONS = [5000, 5000].freeze # 5000x5000

  THUMBNAILS = {
    thumbnail: [50, 50],
    small: [300, 300],
    medium: [600, 600],
    large: [800, 800]
  }.freeze

  plugin :remove_attachment
  plugin :remove_invalid if Rails.configuration.upload_server == :app
  plugin :pretty_location
  plugin :validation_helpers
  plugin :store_dimensions, log_subscriber: nil
  plugin :derivation_endpoint, prefix: 'derivations/image'

  # File validations (requires `validation_helpers` plugin)
  Attacher.validate do
    validate_size 0..MAX_SIZE

    if (validate_extension_inclusion ALLOWED_EXTENSION) && (validate_mime_type ALLOWED_TYPES)
      validate_max_dimensions MAX_DIMENSIONS
    end
  end

  # Thumbnails processor (requires `derivatives` plugin)
  Attacher.derivatives do |original|
    THUMBNAILS.transform_values do |(width, height)|
      GenerateThumbnail.call(original, width, height) # lib/generate_thumbnail.rb
    end
  end

  # Default to dynamic thumbnail URL (requires `default_url` plugin)
  Attacher.default_url do |derivative: nil, **|
    file&.derivation_url(:thumbnail, *THUMBNAILS.fetch(derivative)) if derivative
  end

  # Dynamic thumbnail definition (requires `derivation_endpoint` plugin)
  derivation :thumbnail do |file, width, height|
    GenerateThumbnail.call(file, width.to_i, height.to_i) # lib/generate_thumbnail.rb
  end
end