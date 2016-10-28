class AddInformationAndReferenceToConfirmations < ActiveRecord::Migration
  def self.up
    change_table :confirmations do |t|
      t.text :information
    t.text :reference
    end
  end

  def self.down
    change_table :confirmations do |t|
      t.remove :information
    t.remove :reference
    end
  end
end
