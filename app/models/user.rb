class User < ApplicationRecord
  include Teamable
  before_save :apply_roles_based_on_team

  serialize :active_directory_user_group_ids, Array

  has_many :projects, foreign_key: "caseworker"
  has_many :notes

  scope :order_by_first_name, -> { order(first_name: :asc) }
  scope :team_leaders, -> { where(team_leader: true).order_by_first_name }
  scope :regional_delivery_officers, -> { where(regional_delivery_officer: true).order_by_first_name }
  scope :caseworkers, -> { where(caseworker: true).order_by_first_name }
  scope :enabled, -> { where(disabled_at: nil) }
  scope :disabled, -> { where.not(disabled_at: nil) }

  scope :all_assignable_users, -> { enabled.where.not(caseworker: false).or(where.not(team_leader: false)).or(where.not(regional_delivery_officer: false)) }

  validates :first_name, :last_name, :email, :team, presence: true
  validates :team, presence: true, on: :set_team
  validates :email, uniqueness: {case_sensitive: false}
  validates :email, format: {with: /\A\S+@education.gov.uk\z/}
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  enum :team, USER_TEAMS, suffix: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_role?
    return true if caseworker? || regional_delivery_officer? || team_leader?
    false
  end

  def disabled
    disabled_at.present?
  end

  def disabled=(value)
    if ActiveRecord::Type::Boolean.new.serialize(value)
      write_attribute(:disabled_at, DateTime.now)
    else
      write_attribute(:disabled_at, nil)
    end
  end

  def team_options
    User.teams.keys.map { |team| OpenStruct.new(id: team, name: I18n.t("user.teams.#{team}")) }
  end

  private def apply_roles_based_on_team
    assign_attributes(
      caseworker: apply_regional_caseworker_role?,
      service_support: apply_service_support_role?,
      regional_delivery_officer: apply_regional_delivery_officer_role?,
      team_leader: apply_team_lead_role?
    )
  end

  private def apply_service_support_role?
    team == "service_support"
  end

  private def apply_regional_caseworker_role?
    team == "regional_casework_services" && team_leader == false
  end

  private def apply_regional_delivery_officer_role?
    REGIONAL_TEAMS.value?(team)
  end

  private def apply_team_lead_role?
    team_leader && can_have_team_lead?
  end

  private def can_have_team_lead?
    apply_regional_delivery_officer_role? || team == "regional_casework_services"
  end
end
