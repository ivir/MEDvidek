class Persona < ActiveRecord::Base
  has_many :mobiles
  has_many :sims, through: :mobiles
  has_many :packages, through: :mobiles
  has_many :contact
  has_one  :payment
end

class Contact < ActiveRecord::Base
  belongs_to :persona
end

class Payment < ActiveRecord::Base
  belongs_to :persona
end

class Invoice < ActiveRecord::Base
  belongs_to :sim
end

class Mobile < ActiveRecord::Base
  belongs_to :persona
  belongs_to :sim
  belongs_to :package
end