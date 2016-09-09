class Post < ActiveRecord::Base
  acts_as_ordered_taggable
  extend FriendlyId
  friendly_id :title, use: [:slugged]
  has_and_belongs_to_many :pictures, join_table: :posts_post_pictures, class_name: 'PostPicture'
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :text, presence: true

  before_save :update_pictures
  before_destroy :update_pictures

  SCOPES = %w(recent tagged)

  scope :recent, (lambda do |params = {}|
    Rails.cache.fetch "posts/recent/#{params[:page]}" do
      order('created_at DESC')
        .paginate(per_page: 10, page: params[:page])
        .includes(:pictures, :tags).to_a
    end
  end)

  scope :tagged, (lambda do |params = {}|
    tagged_with(params[:tag])
        .paginate(per_page: 10, page: params[:page])
        .includes(:pictures, :tags).to_a
  end)

  def summary
    text.split('<!--cut-->')[-2] || ''
  end

  def related
    if tags.any?
      find_related_tags.try(:limit, 5) || []
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
