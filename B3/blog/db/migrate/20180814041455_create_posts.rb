class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :kinds
      t.string :author
      t.string :pass

      t.index :title
      t.index :kinds
      t.index :author
      t.index :created_at
      t.index :pass

      t.timestamps
    end
  end
end
