class AddDataToPictures < ActiveRecord::Migration
  def self.up
    add_column :pictures, :data, :string
  end

  def self.down
    remove_column :pictures, :data
  end
end
