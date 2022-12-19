class Project < ApplicationRecord
  SHAREPOINT_URLS = %w[educationgovuk-my.sharepoint.com educationgovuk.sharepoint.com].freeze

  attr_writer :establishment, :incoming_trust

  delegated_type :task_list, types: %w[Conversion::Voluntary::TaskList, Conversion::Involuntary::TaskList], dependent: :destroy

  has_many :sections, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :contacts, dependent: :destroy

  validates :urn, presence: true
  validates :urn, urn: true
  validates :incoming_trust_ukprn, presence: true
  validates :incoming_trust_ukprn, ukprn: true
  validates :provisional_conversion_date, presence: true
  validates :provisional_conversion_date, first_day_of_month: true
  validates :advisory_board_date, presence: true, on: :create
  validates :advisory_board_date, date_in_the_past: true
  validates :establishment_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}, on: :create
  validates :trust_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}, on: :create

  validate :establishment_exists, on: :create, if: -> { urn.present? }
  validate :trust_exists, on: :create, if: -> { incoming_trust_ukprn.present? }

  belongs_to :caseworker, class_name: "User", optional: true
  belongs_to :team_leader, class_name: "User", optional: true
  belongs_to :regional_delivery_officer, class_name: "User", optional: true

  scope :by_provisional_conversion_date, -> { order(provisional_conversion_date: :asc) }

  scope :completed, -> { where.not(completed_at: nil) }
  scope :open, -> { where(completed_at: nil) }

  def establishment
    @establishment ||= fetch_establishment(urn)
  end

  def incoming_trust
    @incoming_trust ||= fetch_trust(incoming_trust_ukprn)
  end

  def completed?
    completed_at.present?
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
