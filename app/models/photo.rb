class Photo < ApplicationRecord
  belongs_to :album

  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  validates :image, presence: true
end
