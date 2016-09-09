class TagsObserver < ActiveRecord::Observer
  observe ActsAsTaggableOn::Tagging

  def after_create(_)
    flush_top_tags
  end

  def after_destroy(_)
    flush_top_tags
  end

  private

  def flush_top_tags
    Rails.cache.delete('most_used_tags')
  end
end
