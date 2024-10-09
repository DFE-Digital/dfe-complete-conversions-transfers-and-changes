class Api::BaseCreateProjectService
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  class CreationError < StandardError; end

  class ValidationError < StandardError
    attr_reader :validation_errors

    def initialize(message, validation_errors)
      super(message)
      @validation_errors = validation_errors.details
    end
  end

  attribute :urn, :integer
  attribute :incoming_trust_ukprn, :integer
  attribute :advisory_board_date, :date
  attribute :advisory_board_conditions, :string
  attribute :created_by_email, :string
  attribute :created_by_first_name, :string
  attribute :created_by_last_name, :string
  attribute :new_trust_reference_number, :string
  attribute :new_trust_name, :string
  attribute :group_id, :string
  attribute :prepare_id, :integer

  validates :urn, presence: true, urn: true
  validate :establishment_exists, if: -> { urn.present? }
  validates_with UrnUniqueForApiValidator

  validates :incoming_trust_ukprn, ukprn: true, if: -> { incoming_trust_ukprn.present? }
  validate :incoming_trust_exists, if: -> { incoming_trust_ukprn.present? }

  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true

  validates :new_trust_reference_number, trust_reference_number: true, if: -> { new_trust_reference_number.present? }
  validates :new_trust_name, presence: true, if: -> { new_trust_reference_number.present? }
  validates :prepare_id, presence: true

  validates :created_by_email, format: {with: /\A\S+@education.gov.uk\z/i}
  validates :created_by_email, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :created_by_first_name, presence: true
  validates :created_by_last_name, presence: true

  validates_with GroupIdValidator

  def initialize(project_params)
    @establishment = nil
    @incoming_trust = nil
    super
  end

  private def group
    return nil unless group_id.present?

    ProjectGroup.find_or_create_by(
      group_identifier: group_id,
      trust_ukprn: incoming_trust_ukprn
    )
  end

  private def find_or_create_user
    user = User.find_or_initialize_by(email: created_by_email)

    unless user.persisted?
      establishment_region = Project.regions.key(establishment.region_code)

      user.assign_attributes(
        first_name: created_by_first_name,
        last_name: created_by_last_name,
        team: establishment_region
      )

      unless user.save
        raise CreationError.new("Failed to save user during API project creation, urn: #{urn}")
      end

    end

    user
  end

  private def establishment_exists
    errors.add(:urn, :no_establishment_found) unless establishment
  end

  private def incoming_trust_exists
    errors.add(:incoming_trust_ukprn, :no_trust_found) unless incoming_trust
  end

  private def establishment
    @establishment ||= fetch_establishment
  end

  private def incoming_trust
    @incoming_trust ||= fetch_trust(incoming_trust_ukprn)
  end

  private def fetch_establishment
    result = Api::AcademiesApi::Client.new.get_establishment(urn)

    if result.object.present?
      @establishment = result.object
    elsif result.error.is_a?(Api::AcademiesApi::Client::NotFoundError)
      nil
    else
      raise CreationError.new("Failed to fetch establishment with URN: #{urn} on Academies API")
    end
  end

  private def fetch_trust(ukprn)
    result = Api::AcademiesApi::Client.new.get_trust(ukprn)

    if result.object.present?
      result.object
    elsif result.error.is_a?(Api::AcademiesApi::Client::NotFoundError)
      nil
    else
      raise CreationError.new("Failed to fetch trust with UKPRN: #{ukprn} on Academies API")
    end
  end
end
