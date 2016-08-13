class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :name, null: false
      t.string :avatar_url
      t.text :text, null: false
      t.string :profile_link
      t.integer :post_id, null: false

      t.timestamps
    end
  end
end
