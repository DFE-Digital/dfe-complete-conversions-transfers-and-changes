class User < ApplicationRecord
  include Teamable
  before_save :apply_roles_based_on_team

  serialize :active_directory_user_group_ids, type: Array, coder: YAML

  has_many :projects, foreign_key: "caseworker"
  has_many :notes
  has_many :user_capabilities
  has_many :capabilities, through: :user_capabilities

  scope :order_by_first_name, -> { order(first_name: :asc) }

  scope :team_leaders, -> { where(manage_team: true).order_by_first_name }

  scope :regional_casework_services, -> { where(team: "regional_casework_services").order_by_first_name }
  scope :caseworkers, -> { regional_casework_services.where(manage_team: false).order_by_first_name }
  scope :regional_casework_services_team_leads, -> { regional_casework_services.where(manage_team: true).order_by_first_name }

  scope :regional_delivery_officers, -> { where(team: User.regional_teams).order_by_first_name }
  scope :regional_delivery_officer_team_leads, -> { regional_delivery_officers.where(manage_team: true).order_by_first_name }

  scope :assignable, -> { where(assign_to_project: true) }
  scope :by_team, ->(team) { where(team: team) }

  scope :active, -> { where(deactivated_at: nil) }
  scope :inactive, -> { where.not(deactivated_at: nil) }

  validates :first_name, :last_name, :email, :team, presence: true
  validates :team, presence: true, on: :set_team
  validates :email, uniqueness: {case_sensitive: false}
  validates :email, format: {with: /\A\S+@education.gov.uk\z/i}
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  enum :team, USER_TEAMS, suffix: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_role?
    return true if assign_to_project? || add_new_project? || manage_team?
    false
  end

  def is_service_support?
    team == "service_support"
  end

  def is_regional_caseworker?
    team == "regional_casework_services" && manage_team == false
  end

  def is_regional_delivery_officer?
    User.regional_teams.include?(team)
  end

  def active
    deactivated_at.nil?
  end

  def active=(value)
    if ActiveRecord::Type::Boolean.new.serialize(value)
      write_attribute(:deactivated_at, nil)
    else
      write_attribute(:deactivated_at, DateTime.now)
    end
  end

  # Override the db column temporarily while we test adding Transfers
  def add_new_project
    is_regional_caseworker? || is_regional_delivery_officer?
  end

  def team_options
    User.teams.keys.map { |team| OpenStruct.new(id: team, name: I18n.t("user.teams.#{team}")) }
  end

  private def apply_roles_based_on_team
    assign_attributes(
      assign_to_project: is_regional_caseworker? || is_regional_delivery_officer?,
      manage_user_accounts: apply_service_support_role?,
      manage_conversion_urns: apply_service_support_role?,
      manage_local_authorities: apply_service_support_role?,
      add_new_project: is_regional_delivery_officer?,
      manage_team: apply_team_lead_role? ||
        UserCapability.has_capability?(user: self, capability_name: :manage_team)
    )
  end

  private def apply_service_support_role?
    team == "service_support"
  end

  private def apply_team_lead_role?
    manage_team && can_be_team_lead?
  end

  private def can_be_team_lead?
    is_regional_delivery_officer? || team == "regional_casework_services"
  end
end
