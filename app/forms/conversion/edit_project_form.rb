class Conversion::EditProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attr_accessor :project, :user

  attribute :establishment_sharepoint_link
  attribute :incoming_trust_sharepoint_link
  attribute :incoming_trust_ukprn
  attribute :advisory_board_date, :date
  attribute :advisory_board_conditions
  attribute :directive_academy_order, :boolean
  attribute :two_requires_improvement, :boolean
  attribute :assigned_to_regional_caseworker_team, :boolean
  attribute :handover_note_body

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :incoming_trust_ukprn, presence: true, ukprn: true
  validates :incoming_trust_ukprn, trust_exists: true, if: -> { incoming_trust_ukprn.present? }

  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true

  validates :directive_academy_order, inclusion: {in: [true, false]}

  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.conversion_project.attributes.two_requires_improvement.inclusion")}

  def self.new_from_project(project, user)
    new(
      project: project,
      establishment_sharepoint_link: project.establishment_sharepoint_link,
      incoming_trust_sharepoint_link: project.incoming_trust_sharepoint_link,
      incoming_trust_ukprn: project.incoming_trust_ukprn,
      advisory_board_date: project.advisory_board_date,
      advisory_board_conditions: project.advisory_board_conditions,
      directive_academy_order: project.directive_academy_order,
      two_requires_improvement: project.two_requires_improvement,
      assigned_to_regional_caseworker_team: project.team.eql?("regional_casework_services"),
      handover_note_body: project.handover_note&.body,
      user: user
    )
  end

  def update(params)
    if GovukDateFieldParameters.new(:advisory_board_date, params).invalid?
      errors.add(:advisory_board_date, :invalid)
      return false
    end

    assign_attributes(params)

    return false unless valid?

    assigned_to = assigned_to_regional_caseworker_team ? nil : project.assigned_to
    assigned_at = assigned_to_regional_caseworker_team ? nil : project.assigned_at
    team = assigned_to_regional_caseworker_team ? "regional_casework_services" : project.team

    project.assign_attributes(
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      incoming_trust_ukprn: incoming_trust_ukprn,
      advisory_board_date: advisory_board_date,
      advisory_board_conditions: advisory_board_conditions,
      directive_academy_order: directive_academy_order,
      two_requires_improvement: two_requires_improvement,
      team: team,
      assigned_to: assigned_to,
      assigned_at: assigned_at
    )

    ActiveRecord::Base.transaction do
      project.save
      update_handover_note if handover_note_body.present?
      notify_team_leaders(project) if assigned_to_regional_caseworker_team
    end

    project
  end

  private def update_handover_note
    note = Note.find_or_initialize_by(project: project, task_identifier: :handover, user: user)
    note.update!(body: handover_note_body)
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later if team_leader.active
    end
  end
end
