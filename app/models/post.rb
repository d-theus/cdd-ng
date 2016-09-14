require 'will_paginate/array'

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

  SCOPES = %w(recent tagged search)

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

  scope :search, (lambda do |params = {}|
    query = sanitize(params[:query].to_s.split.grep(/\w+/).join(' | '))
    return [] if query.blank?
    sql = <<-EOF
    SELECT ranked.*, ts_rank(ranked.doc, to_tsquery(#{query})) AS rank
    FROM (SELECT #{table_name}.*,
         setweight(to_tsvector(coalesce(string_agg(pts.name, ' '))), 'B') || setweight(to_tsvector(#{table_name}.title), 'A') || setweight(to_tsvector(#{table_name}.text ), 'C') AS doc
         FROM #{table_name}
         INNER JOIN (
           SELECT #{ActsAsTaggableOn::Tag.table_name}.name, #{ActsAsTaggableOn::Tagging.table_name}.taggable_id
           FROM #{ActsAsTaggableOn::Tag.table_name}
           INNER JOIN #{ActsAsTaggableOn::Tagging.table_name}
           ON #{ActsAsTaggableOn::Tag.table_name}.id = #{ActsAsTaggableOn::Tagging.table_name}.tag_id AND #{ActsAsTaggableOn::Tagging.table_name}.taggable_type = '#{self}'
         ) AS pts
         ON pts.taggable_id = #{table_name}.id
         GROUP BY #{table_name}.id) AS ranked
    WHERE doc @@ to_tsquery(#{query})
    ORDER BY rank DESC
    EOF
    find_by_sql(sql)
      .paginate(per_page: 10, page: params[:page])
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
