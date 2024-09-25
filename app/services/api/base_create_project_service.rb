class Api::BaseCreateProjectService
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  class CreationError < StandardError; end

  class ValidationError < StandardError; end

  attribute :urn
  attribute :incoming_trust_ukprn
  attribute :advisory_board_date
  attribute :advisory_board_conditions
  attribute :directive_academy_order
  attribute :created_by_email
  attribute :created_by_first_name
  attribute :created_by_last_name
  attribute :new_trust_reference_number
  attribute :new_trust_name
  attribute :group_id
  attribute :prepare_id

  validates :urn, presence: true, urn: true
  validate :establishment_exists, if: -> { urn.present? }
  validates_with UrnUniqueForApiValidator

  validates :incoming_trust_ukprn, ukprn: true, if: -> { incoming_trust_ukprn.present? }
  validates :new_trust_reference_number, trust_reference_number: true, if: -> { new_trust_reference_number.present? }
  validates :new_trust_name, presence: true, if: -> { new_trust_reference_number.present? }
  validates :prepare_id, presence: true

  validates_with GroupIdValidator

  def initialize(project_params)
    @establishment = nil
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
    user = User.find_or_create_by(email: created_by_email)
    establishment_region = Project.regions.key(establishment.region_code)
    unless user.persisted?
      user.update!(first_name: created_by_first_name, last_name: created_by_last_name, team: establishment_region)
    end
    user
  rescue ActiveRecord::RecordInvalid
    raise CreationError.new("Failed to save user during API project creation, urn: #{urn}")
  end

  private def establishment_exists
    errors.add(:urn, :no_establishment_found) unless establishment
  end

  private def establishment
    @establishment ||= fetch_establishment
  end

  private def fetch_establishment
    result = Api::AcademiesApi::Client.new.get_establishment(urn)

    if result.object.present?
      @establishment = result.object
    elsif result.error.is_a?(Api::AcademiesApi::Client::NotFoundError)
      raise ValidationError.new("An establishment with URN: #{urn} could not be found on the Academies API")
    else
      raise CreationError.new("Failed to fetch establishment with URN: #{urn} on Academies API")
    end
  end
end
