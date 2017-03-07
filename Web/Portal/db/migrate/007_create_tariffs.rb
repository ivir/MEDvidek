class CreateTariffs < ActiveRecord::Migration
  def self.up
    create_table :tariffs do |t|
      t.string :user
      t.string :username
      t.string :department
      t.string :division
      t.integer :phone
      t.string :tariffVoice
      t.string :tariffData
      t.string :note
      t.boolean :valid
      t.date :validFrom
      t.date :validTo
      t.date :change
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :tariffs
  end
end
