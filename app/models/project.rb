class Project < ApplicationRecord
  include Teamable
  include SignificantDate

  attr_writer :establishment, :incoming_trust, :member_of_parliament

  delegated_type :tasks_data, types: %w[Conversion::TasksData, Transfer::TasksData], dependent: :destroy
  delegate :local_authority_code, to: :establishment
  delegate :local_authority, to: :establishment
  delegate :director_of_child_services, to: :local_authority

  has_many :notes, dependent: :destroy
  has_many :contacts, dependent: :destroy, class_name: "Contact::Project"
  has_one :funding_agreement_contact, dependent: :destroy, class_name: "Contact::Project", required: false
  has_one :main_contact, dependent: :destroy, class_name: "Contact::Project", required: false
  has_one :establishment_main_contact, dependent: :destroy, class_name: "Contact::Project", required: false
  has_one :incoming_trust_main_contact, dependent: :destroy, class_name: "Contact::Project", required: false

  validates :urn, presence: true
  validates :urn, urn: true
  validates :incoming_trust_ukprn, presence: true
  validates :incoming_trust_ukprn, ukprn: true
  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true
  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  validate :establishment_exists, if: -> { urn.present? }
  validate :trust_exists, if: -> { incoming_trust_ukprn.present? }

  belongs_to :caseworker, class_name: "User", optional: true
  belongs_to :team_leader, class_name: "User", optional: true
  belongs_to :regional_delivery_officer, class_name: "User", optional: true
  belongs_to :assigned_to, class_name: "User", optional: true

  scope :conversions, -> { where(type: "Conversion::Project") }

  scope :completed, -> { where.not(completed_at: nil).order(completed_at: :desc) }
  scope :not_completed, -> { where(completed_at: nil) }
  scope :in_progress, -> { where(completed_at: nil).assigned }

  scope :assigned, -> { where.not(assigned_to: nil) }
  scope :assigned_to_caseworker, ->(user) { where(assigned_to: user).or(where(caseworker: user)) }
  scope :assigned_to_regional_delivery_officer, ->(user) { where(assigned_to: user).or(where(regional_delivery_officer: user)) }

  scope :unassigned_to_user, -> { where assigned_to: nil }
  scope :assigned_to_regional_caseworker_team, -> { where(team: "regional_casework_services") }
  scope :not_assigned_to_regional_caseworker_team, -> { where.not(team: "regional_casework_services") }

  scope :assigned_to, ->(user) { where(assigned_to_id: user.id) }
  scope :assigned_to_users, ->(users) { where(assigned_to_id: [users]) }
  scope :added_by, ->(user) { where(regional_delivery_officer: user) }

  scope :by_region, ->(region) { where(region: region) }

  scope :by_trust_ukprn, ->(ukprn) { where(incoming_trust_ukprn: ukprn) }

  enum :region, {
    london: "H",
    south_east: "J",
    yorkshire_and_the_humber: "D",
    north_west: "B",
    east_of_england: "G",
    west_midlands: "F",
    north_east: "A",
    south_west: "K",
    east_midlands: "E"
  }, suffix: true

  enum :team, PROJECT_TEAMS, suffix: true

  def establishment
    @establishment ||= fetch_establishment(urn)
  end

  def incoming_trust
    @incoming_trust ||= fetch_trust(incoming_trust_ukprn)
  end

  def member_of_parliament
    @member_of_parliament ||= fetch_member_of_parliament
  end

  def completed?
    completed_at.present?
  end

  def unassigned_to_user?
    assigned_to.nil?
  end

  def director_of_child_services
    local_authority = establishment.local_authority
    local_authority&.director_of_child_services
  end

  def type_locale
    type.parameterize(separator: "_")
  end

  def academy_order_type
    :not_applicable
  end

  private def fetch_member_of_parliament
    Api::MembersApi::Client.new.member_for_constituency(establishment.parliamentary_constituency)
  end

  private def fetch_establishment(urn)
    result = Api::AcademiesApi::Client.new.get_establishment(urn)
    raise result.error if result.error.present?

    result.object
  end

  private def fetch_trust(ukprn)
    result = Api::AcademiesApi::Client.new.get_trust(ukprn)
    raise result.error if result.error.present?

    result.object
  end

  private def establishment_exists
    establishment
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:urn, :no_establishment_found)
  end

  private def trust_exists
    incoming_trust
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:incoming_trust_ukprn, :no_trust_found)
  end
end
