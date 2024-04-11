class Transfer::CreateProjectForm < CreateProjectForm
  attr_reader :provisional_transfer_date

  attribute :outgoing_trust_sharepoint_link
  attribute :two_requires_improvement, :boolean
  attribute :inadequate_ofsted, :boolean
  attribute :financial_safeguarding_governance_issues, :boolean
  attribute :outgoing_trust_to_close, :boolean

  validates :outgoing_trust_ukprn, presence: true, ukprn: true
  validates :provisional_transfer_date, presence: true
  validates :provisional_transfer_date, first_day_of_month: true
  validates :assigned_to_regional_caseworker_team, inclusion: {in: [true, false]}
  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.two_requires_improvement.inclusion")}
  validates :inadequate_ofsted, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.inadequate_ofsted.inclusion")}
  validates :financial_safeguarding_governance_issues, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.financial_safeguarding_governance_issues.inclusion")}
  validates :outgoing_trust_to_close, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.outgoing_trust_to_close.inclusion")}

  validate :urn_unique_for_in_progress_transfers, if: -> { urn.present? }

  validates :outgoing_trust_sharepoint_link, presence: true, sharepoint_url: true

  validate :outgoing_trust_exists, if: -> { outgoing_trust_ukprn.present? }

  validates_with OutgoingIncomingTrustsUkprnValidator

  def initialize(params = {})
    @attributes_with_invalid_values = []
    super(params)
  end

  def save
    @project = Transfer::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      outgoing_trust_ukprn: outgoing_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: outgoing_trust_sharepoint_link,
      advisory_board_date: advisory_board_date,
      advisory_board_conditions: advisory_board_conditions,
      transfer_date: provisional_transfer_date,
      two_requires_improvement: two_requires_improvement,
      regional_delivery_officer_id: user.id,
      team: user.team,
      assigned_to: user,
      assigned_at: DateTime.now,
      region: region,
      tasks_data: Transfer::TasksData.new,
      new_trust_reference_number: new_trust_reference_number,
      new_trust_name: new_trust_name
    )

    return nil unless valid?

    ActiveRecord::Base.transaction do
      @project.save
      @note = Note.create(body: handover_note_body, project: @project, user: user, task_identifier: :handover) if handover_note_body
      @project.tasks_data.update!(
        inadequate_ofsted: inadequate_ofsted,
        financial_safeguarding_governance_issues: financial_safeguarding_governance_issues,
        outgoing_trust_to_close: outgoing_trust_to_close
      )
      notify_team_leaders(@project) if assigned_to_regional_caseworker_team
    end

    @project
  end

  def provisional_transfer_date=(hash)
    @provisional_transfer_date = Date.new(value_at_position(hash, 1), value_at_position(hash, 2), value_at_position(hash, 3))
  rescue NoMethodError
    nil
  rescue TypeError, Date::Error, NegativeValueError
    @attributes_with_invalid_values << :provisional_transfer_date
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_transfer_project_created(team_leader, project).deliver_later if team_leader.active
    end
  end

  private def outgoing_trust_exists
    result = Api::AcademiesApi::Client.new.get_trust(outgoing_trust_ukprn)
    raise result.error if result.error.present?
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:outgoing_trust_ukprn, :no_trust_found)
  end
end
