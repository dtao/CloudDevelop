class DropTasks < ActiveRecord::Migration
  def self.up
    drop_table :tasks
  end

  def self.down
    create_table :tasks do |t|
      t.string :description
      t.datetime :deadline
      t.boolean :completed

      t.timestamps
    end
  end
end
