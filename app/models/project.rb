class Project < ApplicationRecord
  has_many :sections

  validates :urn, presence: true, numericality: {only_integer: true}

  belongs_to :delivery_officer, class_name: "User", optional: true
end
