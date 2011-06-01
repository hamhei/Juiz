class ChangeTwitteridIntToString < ActiveRecord::Migration
  def self.up
    change_column :requests, :tweet_id, :string
  end

  def self.down
  end
end
