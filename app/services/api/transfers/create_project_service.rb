class Api::Transfers::CreateProjectService < Api::BaseCreateProjectService
  attribute :provisional_transfer_date, :date
  attribute :outgoing_trust_ukprn, :integer
  attribute :two_requires_improvement, :boolean
  attribute :inadequate_ofsted, :boolean
  attribute :financial_safeguarding_governance_issues, :boolean
  attribute :outgoing_trust_to_close, :boolean

  validates :provisional_transfer_date, presence: true, first_day_of_month: true

  validates :outgoing_trust_ukprn, ukprn: true, if: -> { outgoing_trust_ukprn.present? }
  validate :outgoing_trust_exists, if: -> { outgoing_trust_ukprn.present? }

  def initialize(project_params)
    @outgoing_trust = nil
    super
  end

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
        local_authority: establishment.local_authority,
        new_trust_reference_number: new_trust_reference_number,
        new_trust_name: new_trust_name,
        prepare_id: prepare_id,
        state: :inactive,
        group: group
      )

      if project.save(validate: false)
        project
      else
        raise CreationError.new("Transfer project could not be created via API, urn: #{urn}")
      end
    else
      raise ValidationError.new("Validation error", errors)
    end
  end

  private def outgoing_trust_exists
    errors.add(:outgoing_trust_ukprn, :no_trust_found) unless outgoing_trust
  end

  private def outgoing_trust
    @outgoing_trust ||= fetch_trust(outgoing_trust_ukprn)
  end
end
