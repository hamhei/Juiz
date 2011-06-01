class AddRequestToResponse < ActiveRecord::Migration
  def self.up
    change_table :responses do |t|

    end
  end
  def self.down
    remove_column :responses, :request
  end
end
