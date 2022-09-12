class User < ApplicationRecord
  has_many :projects, foreign_key: "caseworker"
  has_many :notes

  scope :team_leaders, -> { where(team_leader: true) }
  scope :regional_delivery_officers, -> { where(regional_delivery_officer: true) }
  scope :caseworkers, -> { where(caseworker: true) }

  def full_name
    "#{first_name} #{last_name}" if first_name.present? && last_name.present?
  end
end
