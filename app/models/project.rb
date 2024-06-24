class Project < ApplicationRecord
  include Teamable
  include Eventable
  include SignificantDate
  include ApplicationInsightsEventTrackable

  attr_writer :establishment, :incoming_trust, :member_of_parliament

  delegated_type :tasks_data, types: %w[Conversion::TasksData, Transfer::TasksData], dependent: :destroy
  delegate :local_authority_code, to: :establishment
  delegate :local_authority, to: :establishment
  delegate :director_of_child_services, to: :local_authority

  has_many :notes, dependent: :destroy
  has_many :contacts, class_name: "Contact::Project", inverse_of: :project, dependent: :destroy
  has_many :date_history, class_name: "SignificantDateHistory", inverse_of: :project, dependent: :destroy
  has_one :dao_revocation, class_name: "DaoRevocation", inverse_of: :project, dependent: :destroy

  belongs_to :main_contact, inverse_of: :main_contact_for_project, dependent: :destroy, class_name: "Contact::Project", optional: true
  belongs_to :establishment_main_contact, inverse_of: :main_contact_for_establishment, dependent: :destroy, class_name: "Contact::Project", optional: true
  belongs_to :incoming_trust_main_contact, inverse_of: :main_contact_for_incoming_trust, dependent: :destroy, class_name: "Contact::Project", optional: true
  belongs_to :outgoing_trust_main_contact, inverse_of: :main_contact_for_outgoing_trust, dependent: :destroy, class_name: "Contact::Project", optional: true
  belongs_to :funding_agreement_contact, inverse_of: :main_contact_for_funding_agreement, dependent: :destroy, class_name: "Contact::Project", optional: true

  validates :urn, presence: true
  validates :urn, urn: true
  validates :incoming_trust_ukprn, presence: true, unless: -> { new_trust_reference_number.present? }
  validates :incoming_trust_ukprn, ukprn: true, unless: -> { new_trust_reference_number.present? }
  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true
  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :new_trust_reference_number, trust_reference_number: true, if: -> { new_trust_reference_number.present? }

  validate :establishment_exists, if: -> { urn.present? }

  belongs_to :caseworker, class_name: "User", optional: true
  belongs_to :regional_delivery_officer, class_name: "User", optional: true
  belongs_to :assigned_to, class_name: "User", optional: true

  scope :conversions, -> { where(type: "Conversion::Project") }
  scope :transfers, -> { where(type: "Transfer::Project") }

  scope :ordered_by_completed_date, -> { completed.order(completed_at: :desc) }
  scope :in_progress, -> { where(state: 0).assigned }

  scope :assigned, -> { where.not(assigned_to: nil) }
  scope :assigned_to_caseworker, ->(user) { where(assigned_to: user).or(where(caseworker: user)) }
  scope :assigned_to_regional_delivery_officer, ->(user) { where(assigned_to: user).or(where(regional_delivery_officer: user)) }

  scope :unassigned_to_user, -> { where assigned_to: nil }
  scope :assigned_to_regional_caseworker_team, -> { where(team: "regional_casework_services") }
  scope :not_assigned_to_regional_caseworker_team, -> { where.not(team: "regional_casework_services") }

  scope :assigned_to, ->(user) { where(assigned_to_id: user.id) }
  scope :assigned_to_users, ->(users) { where(assigned_to_id: [users]) }
  scope :added_by, ->(user) { where(regional_delivery_officer: user) }

  scope :ordered_by_created_at_date, -> { order(created_at: :desc) }

  scope :by_region, ->(region) { where(region: region) }

  scope :by_trust_ukprn, ->(ukprn) { where(incoming_trust_ukprn: ukprn) }

  scope :filtered_by_advisory_board_date, ->(month, year) { where("MONTH(advisory_board_date) = ?", month).and(where("YEAR(advisory_board_date) = ?", year)) }
  scope :advisory_board_date_in_range, ->(from_date, to_date) {
    where("advisory_board_date >= ?", Date.parse(from_date).at_beginning_of_month)
      .and(where("advisory_board_date <= ?", Date.parse(to_date).at_end_of_month))
      .order(:advisory_board_date)
  }

  scope :not_form_a_mat, -> { where.not(incoming_trust_ukprn: nil) }

  default_scope { where.not(state: :deleted) }

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

  enum :state, {
    active: 0,
    completed: 1,
    deleted: 2
  }

  def establishment
    @establishment ||= fetch_establishment(urn)
  end

  def incoming_trust
    return new_trust_object if form_a_mat?
    @incoming_trust ||= fetch_trust(incoming_trust_ukprn)
  end

  def new_trust_object
    Api::AcademiesApi::Trust.new.from_hash({referenceNumber: new_trust_reference_number, name: new_trust_name})
  end

  def member_of_parliament
    nil
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

  def form_a_mat?
    return true if (new_trust_reference_number && new_trust_name) && !incoming_trust_ukprn
    false
  end

  def all_contacts
    ContactsFetcherService.new(self).all_project_contacts
  end

  # :nocov:
  private def fetch_member_of_parliament
    result = Api::MembersApi::Client.new.member_for_constituency(establishment.parliamentary_constituency)

    if result.error.present?
      track_event(result.error.message)
    else
      result.object
    end
  end
  # :nocov:

  private def fetch_establishment(urn)
    result = Api::AcademiesApi::Client.new.get_establishment(urn)

    if result.error.present?
      track_event(result.error.message)
      raise result.error
    end

    result.object
  end

  private def fetch_trust(ukprn)
    result = Api::AcademiesApi::Client.new.get_trust(ukprn)

    if result.error.present?
      track_event(result.error.message)
      return Api::AcademiesApi::Trust.new.from_hash({referenceNumber: "", name: result.error.message})
    end

    result.object
  end

  private def establishment_exists
    establishment
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:urn, :no_establishment_found)
  end
end
