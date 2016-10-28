class CreateConfirmations < ActiveRecord::Migration
  def self.up
    create_table :confirmations do |t|
      t.string :user
      t.string :mail
      t.string :information
      t.date :sent
      t.date :ack
      t.date :dec
      t.string :reason
      t.string :reference
      t.timestamps
    end
  end

  def self.down
    drop_table :confirmations
  end
end
