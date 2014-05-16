class CreateLink < ActiveRecord::Migration
  def up
    create_table :links do |t|
      t.string :url
      t.string :uid
      t.timestamps
    end

    add_index :links, :url
    add_index :links, :uid
  end

  def down
    drop_table :links
  end
end
