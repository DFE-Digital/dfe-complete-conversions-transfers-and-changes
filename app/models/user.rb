class User < ApplicationRecord
  serialize :active_directory_user_group_ids, Array

  has_many :projects, foreign_key: "caseworker"
  has_many :notes

  scope :order_by_first_name, -> { order(first_name: :asc) }
  scope :team_leaders, -> { where(team_leader: true).order_by_first_name }
  scope :regional_delivery_officers, -> { where(regional_delivery_officer: true).order_by_first_name }
  scope :caseworkers, -> { where(caseworker: true).order_by_first_name }

  scope :all_assignable_users, -> { where.not(caseworker: false).or(where.not(team_leader: false)).or(where.not(regional_delivery_officer: false)) }

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  enum :team, {
    london: "london",
    south_east: "south_east",
    yorkshire_and_the_humber: "yorkshire_and_the_humber",
    north_west: "north_west",
    east_of_england: "east_of_england",
    west_midlands: "west_midlands",
    north_east: "north_east",
    south_west: "south_west",
    east_midlands: "east_midlands",
    regional_casework_services: "regional_casework_services",
    service_support: "service_support",
    academies_operational_practice_unit: "academies_operational_practice_unit",
    education_and_skills_funding_agency: "education_and_skills_funding_agency"
  }, suffix: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_role?
    return true if caseworker? || regional_delivery_officer? || team_leader?
    false
  end
end
