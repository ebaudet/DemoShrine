class ImageUploader < Shrine
  plugin :upload_options, cache: { move: true }, store: { move: true }
  plugin :store_dimensions

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/webp image/gif]
    validate_max_size 5.megabytes
    validate_extension_inclusion %w[jpg jpeg png webp gif]
  end
  plugin :remove_invalid

end