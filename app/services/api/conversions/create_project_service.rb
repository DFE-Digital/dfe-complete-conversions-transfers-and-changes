class Api::Conversions::CreateProjectService
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  class ProjectCreationError < StandardError; end

  attribute :urn
  attribute :incoming_trust_ukprn
  attribute :advisory_board_date
  attribute :advisory_board_conditions
  attribute :provisional_conversion_date
  attribute :directive_academy_order
  attribute :created_by_email
  attribute :created_by_first_name
  attribute :created_by_last_name
  attribute :new_trust_reference_number
  attribute :new_trust_name
  attribute :prepare_id

  validates :urn, presence: true, urn: true
  validates :incoming_trust_ukprn, ukprn: true, if: -> { incoming_trust_ukprn.present? }
  validates :new_trust_reference_number, trust_reference_number: true, if: -> { new_trust_reference_number.present? }
  validates :new_trust_name, presence: true, if: -> { new_trust_reference_number.present? }
  validates :prepare_id, presence: true

  def initialize(project_params)
    super
  end

  def call
    user = find_or_create_user

    if valid?
      tasks_data = Conversion::TasksData.new

      project = Conversion::Project.new(
        urn: urn,
        incoming_trust_ukprn: incoming_trust_ukprn,
        new_trust_reference_number: new_trust_reference_number,
        new_trust_name: new_trust_name,
        conversion_date: provisional_conversion_date,
        advisory_board_date: advisory_board_date,
        advisory_board_conditions: advisory_board_conditions,
        directive_academy_order: directive_academy_order,
        regional_delivery_officer_id: user.id,
        tasks_data: tasks_data,
        region: establishment.region_code,
        prepare_id: prepare_id
      )

      if project.save(validate: false)
        project
      else
        raise ProjectCreationError.new("Project could not be created via API, urn: #{urn}")
      end
    else
      raise ProjectCreationError.new(errors.full_messages.join(" "))
    end
  end

  private def find_or_create_user
    user = User.find_or_create_by(email: created_by_email)
    establishment_region = Project.regions.key(establishment.region_code)
    unless user.persisted?
      user.update!(first_name: created_by_first_name, last_name: created_by_last_name, team: establishment_region)
    end
    user
  rescue ActiveRecord::RecordInvalid
    raise ProjectCreationError.new("Failed to save user during API project creation, urn: #{urn}")
  end

  private def establishment
    result = Api::AcademiesApi::Client.new.get_establishment(urn)
    raise ProjectCreationError.new("Failed to fetch establishment from Academies API during project creation, urn: #{urn}") if result.error.present?

    result.object
  end
end
