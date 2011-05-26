class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.integer :tweet_id
      t.string  :tweet
      t.boolean :check
      t.string  :noblesse
      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
