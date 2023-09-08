class Gias::Establishment < ApplicationRecord
  self.table_name = :gias_establishments

  validates :urn, presence: true
end
