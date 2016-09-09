class AddPicturesCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :pictures_count, :integer, default: 0, null: false
  end
end
