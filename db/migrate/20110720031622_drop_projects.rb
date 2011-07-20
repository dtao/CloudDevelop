class DropProjects < ActiveRecord::Migration
  def self.up
    drop_table :projects
  end

  def self.down
    create_table :projects do |t|
      t.string :name

      t.timestamps
    end
  end
end
