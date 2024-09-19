class Api::Transfers::CreateProjectService < Api::BaseCreateProjectService
  attribute :provisional_transfer_date, :date
  attribute :outgoing_trust_ukprn, :integer
  attribute :two_requires_improvement, :boolean
  attribute :inadequate_ofsted, :boolean
  attribute :financial_safeguarding_governance_issues, :boolean
  attribute :outgoing_trust_to_close, :boolean
  attribute :new_trust_reference_number, :string
  attribute :new_trust_name, :string

  def call
    if valid?
      user = find_or_create_user

      tasks_data = Transfer::TasksData.new(
        inadequate_ofsted: inadequate_ofsted,
        financial_safeguarding_governance_issues: financial_safeguarding_governance_issues,
        outgoing_trust_to_close: outgoing_trust_to_close
      )

      project = Transfer::Project.new(
        urn: urn,
        incoming_trust_ukprn: incoming_trust_ukprn,
        outgoing_trust_ukprn: outgoing_trust_ukprn,
        advisory_board_date: advisory_board_date,
        advisory_board_conditions: advisory_board_conditions,
        transfer_date: provisional_transfer_date,
        two_requires_improvement: two_requires_improvement,
        regional_delivery_officer_id: user.id,
        tasks_data: tasks_data,
        region: establishment.region_code,
        new_trust_reference_number: new_trust_reference_number,
        new_trust_name: new_trust_name,
        prepare_id: prepare_id
      )

      if project.save(validate: false)
        project
      else
        raise CreationError.new("Transfer project could not be created via API, urn: #{urn}")
      end
    else
      raise ValidationError.new(errors.full_messages.join(" "))
    end
  end
end
