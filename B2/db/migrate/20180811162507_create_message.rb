class CreateMessage < ActiveRecord::Migration[5.2]
  def up
    create_table :messages do |t|
      t.string :content
      t.integer :user_id
      t.timestamps
      t.index :user_id
    end
  end

  def down
    drop_table :messages
  end
end
