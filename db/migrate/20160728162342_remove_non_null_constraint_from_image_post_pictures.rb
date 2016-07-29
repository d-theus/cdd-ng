class RemoveNonNullConstraintFromImagePostPictures < ActiveRecord::Migration
  def change
    change_column :post_pictures, :image, :string, null: true
  end
end
