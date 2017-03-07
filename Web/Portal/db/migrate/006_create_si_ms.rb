class CreateSiMs < ActiveRecord::Migration
  def self.up
    create_table :si_ms do |t|
      t.string :serial
      t.integer :phone
      t.boolean :active
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :si_ms
  end
end
