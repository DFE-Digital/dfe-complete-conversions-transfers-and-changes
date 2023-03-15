class Project < ApplicationRecord
  SHAREPOINT_URLS = %w[educationgovuk-my.sharepoint.com educationgovuk.sharepoint.com].freeze

  attr_writer :establishment, :incoming_trust

  delegated_type :task_list, types: %w[Conversion::Voluntary::TaskList, Conversion::Involuntary::TaskList], dependent: :destroy

  has_many :notes, dependent: :destroy
  has_many :contacts, dependent: :destroy

  validates :urn, presence: true
  validates :urn, urn: true
  validates :incoming_trust_ukprn, presence: true
  validates :incoming_trust_ukprn, ukprn: true
  validates :conversion_date, presence: true
  validates :conversion_date, first_day_of_month: true
  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true
  validates :establishment_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}
  validates :trust_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}

  validate :establishment_exists, if: -> { urn.present? }
  validate :trust_exists, if: -> { incoming_trust_ukprn.present? }

  belongs_to :caseworker, class_name: "User", optional: true
  belongs_to :team_leader, class_name: "User", optional: true
  belongs_to :regional_delivery_officer, class_name: "User", optional: true
  belongs_to :assigned_to, class_name: "User", optional: true

  scope :conversions, -> { where(type: "Conversion::Project") }
  scope :conversions_voluntary, -> { conversions.where(task_list_type: "Conversion::Voluntary::TaskList") }
  scope :conversions_involuntary, -> { conversions.where(task_list_type: "Conversion::Involuntary::TaskList") }

  scope :provisional, -> { where(conversion_date_provisional: true) }
  scope :confirmed, -> { where(conversion_date_provisional: false) }

  scope :by_conversion_date, -> { order(conversion_date: :asc) }

  scope :completed, -> { where.not(completed_at: nil) }
  scope :open, -> { where(completed_at: nil) }

  scope :assigned_to_caseworker, ->(user) { where(assigned_to: user).or(where(caseworker: user)) }
  scope :assigned_to_regional_delivery_officer, ->(user) { where(assigned_to: user).or(where(regional_delivery_officer: user)) }

  scope :unassigned_to_user, -> { where assigned_to: nil }
  scope :assigned_to_regional_caseworker_team, -> { where(assigned_to_regional_caseworker_team: true) }

  scope :opening_by_month_year, ->(month, year) { includes(:task_list).where(conversion_date_provisional: false).and(where("YEAR(conversion_date) = ?", year)).and(where("MONTH(conversion_date) = ?", month)) }

  def establishment
    @establishment ||= fetch_establishment(urn)
  end

  def incoming_trust
    @incoming_trust ||= fetch_trust(incoming_trust_ukprn)
  end

  def completed?
    completed_at.present?
  end

  def unassigned_to_user?
    assigned_to.nil?
  end

  def all_conditions_met?
    task_list.conditions_met_confirm_all_conditions_met?
  end

  private def fetch_establishment(urn)
    result = AcademiesApi::Client.new.get_establishment(urn)
    raise result.error if result.error.present?

    result.object
  end

  private def fetch_trust(ukprn)
    result = AcademiesApi::Client.new.get_trust(ukprn)
    raise result.error if result.error.present?

    result.object
  end

  private def establishment_exists
    establishment
  rescue AcademiesApi::Client::NotFoundError
    errors.add(:urn, :no_establishment_found)
  end

  private def trust_exists
    incoming_trust
  rescue AcademiesApi::Client::NotFoundError
    errors.add(:incoming_trust_ukprn, :no_trust_found)
  end
end
