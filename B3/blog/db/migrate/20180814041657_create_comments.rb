class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :commenter
      t.string :author
      t.integer :article_id

      t.index :author

      t.timestamps
    end
  end
end
