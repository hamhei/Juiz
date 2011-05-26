class AddUrlToRequest < ActiveRecord::Migration
  def self.up
    add_column :requests, :tweet_url, :string
  end

  def self.down
    remove_column :requests, :tweet_url
  end
end
