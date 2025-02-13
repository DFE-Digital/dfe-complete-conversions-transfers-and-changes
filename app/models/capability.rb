class Capability < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :description, presence: true
end
