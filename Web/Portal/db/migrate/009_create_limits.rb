class CreateLimits < ActiveRecord::Migration
  def self.up
    create_table :limits do |t|
      t.text :name
      t.text :parameter
      t.timestamps null: false
    end

    create_table :tariffs do |t|
      t.belongs_to :limit, index:true
      t.text :name
      t.float :price
      t.timestamps null: false
    end

    create_table :packages do |t|
      t.text :name
      t.timestamps null: false
    end

    create_table :packages_tariffs, id: false do |t|
      t.belongs_to :package, index: true
      t.belongs_to :tariff, index: true
    end

  end

  def self.down
    drop_table :packages_tariffs
    drop_table :packages
    drop_table :tariffs
    drop_table :limits
  end
end
