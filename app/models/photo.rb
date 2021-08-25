class Photo < ApplicationRecord
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  validates :image, presence: true
end
