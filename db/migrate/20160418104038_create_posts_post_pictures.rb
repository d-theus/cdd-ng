class CreatePostsPostPictures < ActiveRecord::Migration
  def change
    create_table :posts_post_pictures do |t|
      t.integer :post_id, null: false
      t.integer :post_picture_id, null: false
    end
  end
end
