class AddThumbnailDataToPictures < ActiveRecord::Migration
  def self.up
    add_column :pictures, :thumbnail_data, :string
  end

  def self.down
    remove_column :pictures, :thumbnail_data
  end
end
