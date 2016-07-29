class AddImageTmpToPostPictures < ActiveRecord::Migration
  def change
    add_column :post_pictures, :image_tmp, :string
  end
end
