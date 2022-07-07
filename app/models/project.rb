class Project < ApplicationRecord
  validates :urn, presence: true, numericality: {only_integer: true}

  belongs_to :delivery_officer, class_name: "User", optional: true
end
