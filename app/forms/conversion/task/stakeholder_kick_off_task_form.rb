class Conversion::Task::StakeholderKickOffTaskForm < ::BaseTaskForm
  include ConversionDatable

  attribute :introductory_emails, :boolean
  attribute :local_authority_proforma, :boolean
  attribute :setup_meeting, :boolean
  attribute :meeting, :boolean
  attribute :check_provisional_conversion_date, :boolean

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    super(@tasks_data, @user)
  end

  def save
    if @project.conversion_date_provisional? && confirmed_conversion_date.present?
      ::SignificantDateCreatorService.new(
        project: @project,
        revised_date: confirmed_conversion_date,
        note_body: "Conversion date confirmed as part of the External stakeholder kick off task.",
        user: @user
      ).update!
    end

    @tasks_data.assign_attributes(
      stakeholder_kick_off_introductory_emails: introductory_emails,
      stakeholder_kick_off_local_authority_proforma: local_authority_proforma,
      stakeholder_kick_off_setup_meeting: setup_meeting,
      stakeholder_kick_off_meeting: meeting,
      stakeholder_kick_off_check_provisional_conversion_date: check_provisional_conversion_date
    )
    @tasks_data.save!
  end

  def completed?
    attributes.except(
      "confirmed_conversion_date(3i)",
      "confirmed_conversion_date(2i)",
      "confirmed_conversion_date(1i)"
    ).values.all?(&:present?) && @project.conversion_date_provisional? == false
  end

  def in_progress?
    attributes.values.any?(&:present?) || @project.conversion_date_provisional? == false
  end
end
