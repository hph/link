class UpdateLinks < ActiveRecord::Migration
  def change
    change_column :links, :url, :text, null: false
    change_column :links, :created_at, :datetime, null: false
    remove_column :links, :updated_at
  end
end
