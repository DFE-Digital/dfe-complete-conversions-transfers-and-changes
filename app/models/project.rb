class Project < ApplicationRecord
  validates :urn, presence: true, numericality: {only_integer: true}
end
