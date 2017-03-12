class CreateSiMs < ActiveRecord::Migration
  def self.up
    create_table :sims do |t|
      t.string :serial
      t.integer :phone
      t.boolean :active
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :sims
  end
end
