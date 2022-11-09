class Project < ApplicationRecord
  SHAREPOINT_URLS = %w[educationgovuk-my.sharepoint.com educationgovuk.sharepoint.com].freeze

  before_validation :add_invalid_date_errors

  has_many :sections, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :contacts, dependent: :destroy

  accepts_nested_attributes_for :notes, reject_if: proc { |attributes| attributes[:body].blank? }

  validates :urn, presence: true, numericality: {only_integer: true}, length: {is: 6}
  validates :incoming_trust_ukprn, presence: true, numericality: {only_integer: true}
  validates :target_completion_date, presence: true
  validates :incoming_trust_ukprn, ukprn: true
  validates :advisory_board_date, presence: true, on: :create
  validates :advisory_board_date, past_date: true
  validates :establishment_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}, on: :create
  validates :trust_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}, on: :create

  validate :first_day_of_month
  validate :target_completion_date_is_in_the_future, on: :create
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

  enum project_type: {
    conversion: 0
  }

  def establishment
    @establishment ||= fetch_establishment(urn)
  end

  def incoming_trust
    @incoming_trust ||= fetch_trust(incoming_trust_ukprn)
  end

  # Rescue argument error raised when value
  # cannot be parsed as a `Date`. For example,
  # `-1, -1, -2` or `42, 0, 2022`
  def advisory_board_date=(value)
    @advisory_board_date_invalid = false
    super
  rescue ArgumentError
    @advisory_board_date_invalid = true
  end

  # Rescue argument error raised when value
  # cannot be parsed as a `Date`. For example,
  # `-1, -1, -2` or `42, 0, 2022`
  def target_completion_date=(value)
    @target_completion_date_invalid = false
    super
  rescue ArgumentError
    @target_completion_date_invalid = true
  end

  def closed?
    closed_at.present?
  end

  private def add_invalid_date_errors
    errors.add(:advisory_board_date, :invalid) if @advisory_board_date_invalid
    errors.add(:target_completion_date, :invalid) if @target_completion_date_invalid
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

    # Target completion date is always the 1st of the month.
    if target_completion_date.day != 1
      errors.add(:target_completion_date, :must_be_first_of_the_month)
    end
  end

  private def target_completion_date_is_in_the_future
    return if target_completion_date.nil?

    unless target_completion_date.future?
      errors.add(:target_completion_date, :must_be_in_the_future)
    end
  end
end
