class Api::Conversions::CreateProjectService < Api::BaseCreateProjectService
  attribute :provisional_conversion_date, :date
  attribute :directive_academy_order, :boolean

  validates :provisional_conversion_date, first_day_of_month: true

  def call
    if valid?
      user = find_or_create_user

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
        prepare_id: prepare_id,
        group: group,
        state: :inactive
      )

      if project.save(validate: false)
        project
      else
        raise CreationError.new("Conversion project could not be created via API, urn: #{urn}")
      end
    else
      raise ValidationError.new("Validation error", errors)
    end
  end
end
