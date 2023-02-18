class Address < ApplicationRecord
  has_and_belongs_to_many :users

  validates_presence_of :zipcode, :result

  def self.valid_zip(zip)
    /^\d{5}-?\d{3}$/.match zip
  end
end
