class LocalAuthority < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true
  validates :code, uniqueness: true
  validates :address_1, presence: true
  validates :address_postcode, presence: true, postcode: true

  def address
    [
      address_1,
      address_2,
      address_3,
      address_town,
      address_county,
      address_postcode
    ]
  end
end
