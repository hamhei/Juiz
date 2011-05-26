class AddProfileToRequest < ActiveRecord::Migration
  def self.up
    add_column :requests, :profile_image_url, :string
  end

  def self.down
    remove_column :requests, :profile_image_url
  end
end
