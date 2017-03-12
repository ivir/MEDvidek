class CreateAccountings < ActiveRecord::Migration
  def self.up
    create_table :accountings do |t|
      t.string :username
      t.string :name
      t.string :surname
      t.integer :division
      t.integer :department
      t.integer :phone
      t.float :voice
      t.float :data
      t.float :roaming
      t.date :from
      t.date :to
      t.text :note
      t.boolean :disabled
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :accountings
  end
end
