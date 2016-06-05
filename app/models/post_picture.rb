class PostPicture < ActiveRecord::Base
  validates :image, presence: true
  validates :slug, uniqueness: true
  has_many  :posts, join_table: :posts_post_pictures
  extend FriendlyId
  friendly_id :caption, use: [:slugged]

  mount_uploader :image, PostPictureUploader

  private

  def should_generate_new_friendly_id?
    slug.blank? || caption_changed?
  end
end
