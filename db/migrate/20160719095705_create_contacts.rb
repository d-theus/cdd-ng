class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :reply, null: false
      t.boolean :unread, default: true
      t.text :content, null: false, length: { maximum: 65_536 }

      t.timestamps
    end
  end
end
