class CreateTravels < ActiveRecord::Migration
  def self.up
    create_table :travels do |t|
      t.integer :phone
      t.date :from
      t.date :till
      t.integer :package_id
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :travels
  end
end
