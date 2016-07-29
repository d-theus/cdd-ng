class AddImageTmpToWorks < ActiveRecord::Migration
  def change
    add_column :works, :image_tmp, :string
  end
end
