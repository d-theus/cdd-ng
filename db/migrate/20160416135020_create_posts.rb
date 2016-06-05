class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :text, null: false
      t.string :slug, uniq: true

      t.timestamps
    end
  end
end
