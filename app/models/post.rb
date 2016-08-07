class Post < ActiveRecord::Base
  acts_as_ordered_taggable
  extend FriendlyId
  friendly_id :title, use: [:slugged]
  has_and_belongs_to_many :pictures, join_table: :posts_post_pictures, class_name: 'PostPicture'

  validates :title, presence: true
  validates :text, presence: true

  before_save :update_pictures
  before_destroy :update_pictures

  def summary
    text.split('<!--cut-->')[-2] || ''
  end

  def related
    if tags.any?
      find_related_tags.limit(5)
    else
      []
    end
  end

  private

  def should_generate_new_friendly_id?
    slug.blank?
  end

  def update_pictures
    slugs = text.scan(/!\[.*\]\(((?!https?|\/)\S+).*\)/)
    ids = PostPicture.where(slug: slugs).pluck(:id)
    self.picture_ids = ids
  end
end
