class User < ApplicationRecord
  has_many :projects, foreign_key: "caseworker"
  has_many :notes

  scope :caseworkers, -> { where(caseworker: true) }

  def full_name
    "#{first_name} #{last_name}" if first_name.present? && last_name.present?
  end
end
