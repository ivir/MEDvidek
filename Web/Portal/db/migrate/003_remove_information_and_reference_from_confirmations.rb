class RemoveInformationAndReferenceFromConfirmations < ActiveRecord::Migration
  def self.up
    change_table :confirmations do |t|
      t.remove :information
    t.remove :reference
    end
  end

  def self.down
    change_table :confirmations do |t|
      t.string :information
    t.string :reference
    end
  end
end
