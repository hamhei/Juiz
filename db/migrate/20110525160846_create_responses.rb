class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer :tweet_id
      t.string  :tweet
      t.timestamps
    end
  end

  def self.down
    drop_table :responses
  end
end
