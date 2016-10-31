class CreateBillings < ActiveRecord::Migration
  def self.up
    create_table :billings do |t|
      t.string :user
      t.string :name
      t.string :department
      t.integer :phonenumber
      t.date :month
      t.float :limit
      t.float :total
      t.float :others
      t.float :overlimit
      t.float :pay
      t.timestamps
    end
  end

  def self.down
    drop_table :billings
  end
end
