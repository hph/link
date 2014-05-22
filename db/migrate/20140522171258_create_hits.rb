class CreateHits < ActiveRecord::Migration
  def up
    create_table :hits do |t|
      t.integer :link_id, null: false
      t.string :ip_address, null: false
      t.datetime :created_at, null: false
    end
  end

  def down
    drop_table :hits
  end
end
