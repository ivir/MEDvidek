class Tariff < ActiveRecord::Base
  belongs_to :limit
  has_and_belongs_to_many :packages
end
