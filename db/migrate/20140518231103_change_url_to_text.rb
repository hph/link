class ChangeUrlToText < ActiveRecord::Migration
  def change
    change_column :links, :url, :text
  end
end
