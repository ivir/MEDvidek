class Package < ActiveRecord::Base
  has_and_belongs_to_many :tariffs
  has_many :travels
  
  has_many :mobiles, dependent: :delete_all
  has_many :sims, through: :mobiles
  has_many :personas, through: :mobiles
end
