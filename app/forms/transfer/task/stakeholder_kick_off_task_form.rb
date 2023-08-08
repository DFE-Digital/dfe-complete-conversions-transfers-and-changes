class Transfer::Task::StakeholderKickOffTaskForm < BaseTaskForm
  include TransferDatable

  attribute :introductory_emails, :boolean
  attribute :setup_meeting, :boolean
  attribute :meeting, :boolean

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    super(@tasks_data, @user)
  end

  def save
    if @project.transfer_date_provisional? && confirmed_transfer_date.present?
      SignificantDateCreatorService.new(
        project: @project,
        revised_date: confirmed_transfer_date,
        note_body: "Transfer date confirmed as part of the External stakeholder kick off task.",
        user: @user
      ).update!
    end

    @tasks_data.assign_attributes(
      stakeholder_kick_off_introductory_emails: introductory_emails,
      stakeholder_kick_off_setup_meeting: setup_meeting,
      stakeholder_kick_off_meeting: meeting
    )

    @tasks_data.save!
  end

  def completed?
    attributes.except(
      "confirmed_transfer_date(3i)",
      "confirmed_transfer_date(2i)",
      "confirmed_transfer_date(1i)"
    ).values.all?(&:present?) && @project.transfer_date_provisional? == false
  end

  def in_progress?
    attributes.values.any?(&:present?) || @project.transfer_date_provisional? == false
  end
end
