class AddSlugToPostPictures < ActiveRecord::Migration
  def change
    add_column :post_pictures, :slug, :string
    add_index :post_pictures, :slug, unique: true
  end
end
