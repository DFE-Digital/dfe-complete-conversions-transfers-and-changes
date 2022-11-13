class Project < ApplicationRecord
  SHAREPOINT_URLS = %w[educationgovuk-my.sharepoint.com educationgovuk.sharepoint.com].freeze

  has_many :sections, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :contacts, dependent: :destroy

  accepts_nested_attributes_for :notes, reject_if: proc { |attributes| attributes[:body].blank? }

  validates :urn, presence: true
  validates :urn, urn: true
  validates :incoming_trust_ukprn, presence: true, numericality: {only_integer: true}
  validates :target_completion_date, presence: true
  validates :target_completion_date, date_in_the_future: true
  validates :incoming_trust_ukprn, ukprn: true
  validates :advisory_board_date, presence: true, on: :create
  validates :advisory_board_date, date_in_the_past: true
  validates :establishment_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}, on: :create
  validates :trust_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}, on: :create

  validate :first_day_of_month
  validate :establishment_exists, :trust_exists, on: :create

  belongs_to :caseworker, class_name: "User", optional: true
  belongs_to :team_leader, class_name: "User", optional: true
  belongs_to :regional_delivery_officer, class_name: "User", optional: true

  scope :by_target_completion_date, -> { order(target_completion_date: :asc) }

  # This works under MSSQL because it puts NULL at the front, and we can't make it more robust because TinyTDS won't
  # play nicely with things like IS NULL and NULLS LAST. If you're running this under a different database and the
  # order is suddenly inverted, go check out https://michaeljherold.com/articles/null-based-ordering-in-activerecord/
  # and see if you can use Arel to build a proper query.
  scope :by_closed_state, -> { order(:closed_at) }

  def establishment
    @establishment ||= fetch_establishment(urn)
  end

  def incoming_trust
    @incoming_trust ||= fetch_trust(incoming_trust_ukprn)
  end

  def closed?
    closed_at.present?
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

  private def first_day_of_month
    return if target_completion_date.nil?

    if target_completion_date.day != 1
      errors.add(:target_completion_date, :must_be_first_of_the_month)
    end
  end
end
