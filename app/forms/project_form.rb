class ProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  VALID_SHAREPOINT_URLS = %w[educationgovuk-my.sharepoint.com educationgovuk.sharepoint.com].freeze

  before_validation :advisory_board_date, :target_completion_date, :add_invalid_date_errors

  attribute :urn, :integer
  attribute :incoming_trust_ukprn, :integer
  attribute :target_completion_date, :date
  attribute :advisory_board_date, :date
  attribute :advisory_board_conditions
  attribute :establishment_sharepoint_link
  attribute :trust_sharepoint_link
  attribute :regional_delivery_officer_id
  attribute :note_body

  validates :urn, presence: true, numericality: {only_integer: true}, length: {is: 6}
  validates :incoming_trust_ukprn, presence: true, ukprn: true, numericality: {only_integer: true}
  validates :target_completion_date, presence: true
  validates :advisory_board_date, presence: true
  validates :advisory_board_date, past_date: true
  validates :establishment_sharepoint_link, presence: true, url: {hostnames: VALID_SHAREPOINT_URLS}
  validates :trust_sharepoint_link, presence: true, url: {hostnames: VALID_SHAREPOINT_URLS}
  validate :first_day_of_month, :target_completion_date_is_in_the_future, :establishment_exists, :trust_exists

  def create
    return false if invalid?

    project = Project.create!(
      urn:,
      incoming_trust_ukprn:,
      target_completion_date:,
      advisory_board_date:,
      advisory_board_conditions:,
      establishment_sharepoint_link:,
      trust_sharepoint_link:,
      regional_delivery_officer_id:
    )

    unless note_body.blank?
      Note.create!(
        project:,
        body: note_body,
        user_id: regional_delivery_officer_id
      )
    end

    project
  end

  # Rescue argument error raised when value cannot be parsed as
  # a `Date`. For example, `-1, -1, -2` or `42, 0, 2022`
  def advisory_board_date=(value)
    @advisory_board_date_invalid = false
    super
  rescue ArgumentError
    @advisory_board_date_invalid = true
  end

  # Rescue argument error raised when value cannot be parsed as
  # a `Date`. For example, `-1, -1, -2` or `42, 0, 2022`
  def target_completion_date=(value)
    @target_completion_date_invalid = false
    super
  rescue ArgumentError
    @target_completion_date_invalid = true
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

  private def add_invalid_date_errors
    errors.add(:advisory_board_date, :invalid) if @advisory_board_date_invalid
    errors.add(:target_completion_date, :invalid) if @target_completion_date_invalid
  end

  private def establishment_exists
    result = AcademiesApi::Client.new.get_establishment(urn)
    raise result.error if result.error.present?
  rescue AcademiesApi::Client::NotFoundError
    errors.add(:urn, :no_establishment_found)
  end

  private def trust_exists
    result = AcademiesApi::Client.new.get_trust(incoming_trust_ukprn)
    raise result.error if result.error.present?
  rescue AcademiesApi::Client::NotFoundError
    errors.add(:incoming_trust_ukprn, :no_trust_found)
  end
end
