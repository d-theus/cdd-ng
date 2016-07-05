class Work < ActiveRecord::Base
  validates :title, presence: true, length: { within: 2..256 }
  validates :description, presence: true, length: { within:  2..1024 }
  mount_uploader :image, WorkPicturesUploader
end
