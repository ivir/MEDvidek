class CreatePersonas < ActiveRecord::Migration
  def self.up
    create_table :personas do |t|
      t.text :name
      t.text :surname
      t.text :username
      t.text :title
      t.text :postitle
      t.text :department
      t.timestamps null: false
      t.belongs_to :contact, index:true
      t.belongs_to :payment, index:true
    end

    create_table :contacts do |t|
      t.belongs_to :persona, index:true
      t.text :type
      t.text :value
    end

    create_table :payments do |t|
      t.belongs_to :persona, index:true
      t.text :type
      t.text :value
    end

    create_table :invoices do |t|
      t.belongs_to :sim, index:true
      t.float :total
      t.float :others
      t.float :request
      t.date :month
      t.boolean :correction
      t.timestamps null: false
    end


    create_table :mobiles do |t|
      t.belongs_to :persona, index: true
      t.belongs_to :sim, index: true
      t.belongs_to :package, index: true
      t.date :from
      t.date :to
      t.timestamps null:false
    end

  end

  def self.down
    drop_table :mobiles
    drop_table :personas
    drop_table :invoices
    drop_table :contacts
    drop_table :payments
  end
end
