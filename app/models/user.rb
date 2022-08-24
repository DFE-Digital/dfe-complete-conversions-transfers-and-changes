class User < ApplicationRecord
  has_many :projects, foreign_key: "caseworker"
  has_many :notes

  scope :caseworkers, -> { where(team_leader: false).and(where(regional_delivery_officer: false)) }
end
