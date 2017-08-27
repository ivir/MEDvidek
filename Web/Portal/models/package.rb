class Package < ActiveRecord::Base
  has_and_belongs_to_many :tariffs
  has_many :travels
end
