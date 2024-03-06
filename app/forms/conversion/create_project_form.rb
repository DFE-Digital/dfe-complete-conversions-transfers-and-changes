class Conversion::CreateProjectForm < CreateProjectForm
  attribute :directive_academy_order, :boolean
  attribute :region
  attribute :two_requires_improvement, :boolean

  attr_reader :provisional_conversion_date

  validates :provisional_conversion_date, presence: true
  validates :provisional_conversion_date, first_day_of_month: true

  validates :urn, presence: true, existing_academy: true
  validate :urn_unique_for_in_progress_conversions, if: -> { urn.present? }

  validates :directive_academy_order, :assigned_to_regional_caseworker_team, inclusion: {in: [true, false]}
  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.conversion_project.attributes.two_requires_improvement.inclusion")}

  def initialize(params = {})
    @attributes_with_invalid_values = []
    super(params)
  end

  def provisional_conversion_date=(hash)
    @provisional_conversion_date = Date.new(value_at_position(hash, 1), value_at_position(hash, 2), value_at_position(hash, 3))
  rescue NoMethodError
    nil
  rescue TypeError, Date::Error
    @attributes_with_invalid_values << :provisional_conversion_date
  end

  def region
    @region = establishment.region_code
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later if team_leader.active
    end
  end

  private def urn_unique_for_in_progress_conversions
    errors.add(:urn, :duplicate) if Conversion::Project.not_completed.where(urn: urn).any?
  end

  def directive_academy_order_responses
    @directive_academy_order_responses ||= [
      OpenStruct.new(id: true, name: I18n.t("helpers.responses.conversion_project.directive_academy_order.yes")),
      OpenStruct.new(id: false, name: I18n.t("helpers.responses.conversion_project.directive_academy_order.no"))
    ]
  end

  def save
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
      tasks_data: new_tasks_data,
      new_trust_reference_number: new_trust_reference_number,
      new_trust_name: new_trust_name
    )

    return nil unless valid?

    ActiveRecord::Base.transaction do
      @project.save
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
