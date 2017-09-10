class Sim < ActiveRecord::Base
  has_many :personas, through: :mobiles
  has_many :invoices
  has_many :packages, through: :mobiles
end
