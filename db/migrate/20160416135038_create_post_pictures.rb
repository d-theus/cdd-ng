class CreatePostPictures < ActiveRecord::Migration
  def change
    create_table :post_pictures do |t|
      t.string :caption, default: ''
      t.string :image, null: false

      t.timestamps
    end
  end
end
