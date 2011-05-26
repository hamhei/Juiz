class AddTweetToRequest < ActiveRecord::Migration
  def self.up
    add_column :requests, :tweet_datetime, :string
  end

  def self.down
    remove_column :requests, :tweet_datetime
  end
end
