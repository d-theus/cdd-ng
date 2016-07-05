class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :website_link
      t.string :github_link
      t.string :image

      t.timestamps
    end
  end
end
