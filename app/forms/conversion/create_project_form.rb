class Conversion::CreateProjectForm < CreateProjectForm
  attribute :directive_academy_order, :boolean
  attribute :two_requires_improvement, :boolean
  attribute :provisional_conversion_date, :date

  validates :provisional_conversion_date, presence: true
  validates :provisional_conversion_date, first_day_of_month: true

  validates :urn, presence: true, existing_academy: true
  validate :urn_unique_for_in_progress_conversions, if: -> { urn.present? }

  validates :directive_academy_order, :assigned_to_regional_caseworker_team, inclusion: {in: [true, false]}
  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.conversion_project.attributes.two_requires_improvement.inclusion")}

  validates_with FormAMultiAcademyTrustNameValidator

  def initialize(attributes = {})
    # if any of the three date fields are invalid, clear them all to prevent multiparameter
    # assignment errors, this essential makes the provisonal date nil, but is the best we can do
    if GovukDateFieldParameters.new(:provisional_conversion_date, attributes).invalid?
      attributes[:"provisional_conversion_date(3i)"] = ""
      attributes[:"provisional_conversion_date(2i)"] = ""
      attributes[:"provisional_conversion_date(1i)"] = ""
    end

    super
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later if team_leader.active
    end
  end

  private def urn_unique_for_in_progress_conversions
    errors.add(:urn, :duplicate) if Conversion::Project.where(urn: urn, state: [:inactive, :active]).any?
  end

  def save(context = nil)
    assigned_to = assigned_to_regional_caseworker_team ? nil : user
    assigned_at = assigned_to_regional_caseworker_team ? nil : DateTime.now

    team = assigned_to_regional_caseworker_team ? "regional_casework_services" : Project.teams[Project.regions.key(region)]

    @project = Conversion::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      advisory_board_conditions: advisory_board_conditions,
      conversion_date: provisional_conversion_date,
      advisory_board_date: advisory_board_date,
      regional_delivery_officer_id: user.id,
      team: team,
      assigned_to: assigned_to,
      assigned_at: assigned_at,
      directive_academy_order: directive_academy_order,
      two_requires_improvement: two_requires_improvement,
      region: region,
      local_authority: local_authority,
      tasks_data: new_tasks_data,
      new_trust_reference_number: new_trust_reference_number,
      new_trust_name: new_trust_name
    )

    return nil unless valid?(context)

    ActiveRecord::Base.transaction do
      if group_id.present?
        @project.group = ProjectGroup.find_or_create_by(
          group_identifier: group_id,
          trust_ukprn: incoming_trust_ukprn
        )
      end

      @project.save!

      @note = Note.create(body: handover_note_body, project: @project, user: user, task_identifier: :handover) if handover_note_body
      notify_team_leaders(@project) if assigned_to_regional_caseworker_team
      Event.log(grouping: :project, user: user, with: @project, message: "Project created.")
    end

    @project
  end

  def new_tasks_data
    Conversion::TasksData.new(
      church_supplemental_agreement_not_applicable: church_supplemental_agreement_not_applicable?,
      sponsored_support_grant_not_applicable: sponsored_support_grant_not_applicable?
    )
  end

  private def church_supplemental_agreement_not_applicable?
    return true unless establishment.has_diocese?
    false
  end

  private def sponsored_support_grant_not_applicable?
    return true if directive_academy_order == false
    false
  end
end
