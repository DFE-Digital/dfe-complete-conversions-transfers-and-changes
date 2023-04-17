class LocalAuthority < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true
  validates :address_1, presence: true
  validates :address_postcode, presence: true, postcode: true
end
