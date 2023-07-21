class Transfer::CreateProjectForm < CreateProjectForm
  validates :outgoing_trust_ukprn, presence: true, ukprn: true

  validate :urn_unique_for_in_progress_transfers, if: -> { urn.present? }

  def initialize(params = {})
    @attributes_with_invalid_values = []
    super(params)
  end

  def save
    @project = Transfer::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      outgoing_trust_ukprn: incoming_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      trust_sharepoint_link: trust_sharepoint_link,
      advisory_board_date: advisory_board_date,
      regional_delivery_officer_id: user.id,
      team: user.team,
      assigned_to: user,
      assigned_at: DateTime.now,
      region: region,
      tasks_data: Transfer::TasksData.new
    )

    return nil unless valid?

    ActiveRecord::Base.transaction do
      @project.save
    end

    @project
  end
end
