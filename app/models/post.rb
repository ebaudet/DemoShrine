class Post < ApplicationRecord
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  validates :name, presence: true

end
