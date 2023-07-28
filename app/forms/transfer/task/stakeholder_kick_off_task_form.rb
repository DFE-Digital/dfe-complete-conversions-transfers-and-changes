class Transfer::Task::StakeholderKickOffTaskForm < BaseTaskForm
  include TransferDatable

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
