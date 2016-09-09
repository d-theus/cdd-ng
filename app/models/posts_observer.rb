class PostsObserver < ActiveRecord::Observer
  observe :post

  def after_create(_)
    flush_recent
  end

  def after_destroy(_)
    flush_recent
  end

  private

  def flush_recent
    Rails.cache.delete_matched('posts/recent/*')
  end
end
