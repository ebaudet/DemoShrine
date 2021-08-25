class Album < ApplicationRecord
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  include ImageUploader::Attachment(:cover_photo) # adds an `image` virtual attribute

  validates :name, presence: true
  validates :cover_photo, presence: true
end
