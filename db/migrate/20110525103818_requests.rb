class Requests < ActiveRecord::Migration
  def self.up
    add_column :requests, :tweet, :string
  end

  def self.down
  end
end
