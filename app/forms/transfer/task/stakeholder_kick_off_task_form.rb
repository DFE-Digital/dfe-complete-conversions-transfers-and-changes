class Transfer::Task::StakeholderKickOffTaskForm < BaseTaskForm
  include SignificantDatable

  attribute :check_significant_date, :boolean

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    super(@tasks_data, @user)
  end

  def save
    if @project.significant_date_provisional? && confirmed_significant_date.present?
      SignificantDateUpdater.new(
        project: @project,
        revised_date: confirmed_significant_date,
        note_body: "Transfer date confirmed as part of the External stakeholder kick off task.",
        user: @user
      ).update!
    end

    @tasks_data.assign_attributes(stakeholder_kick_off_check_significant_date: check_significant_date)
    @tasks_data.save!
  end

  def completed?
    attributes.except(
      "confirmed_significant_date(3i)",
      "confirmed_significant_date(2i)",
      "confirmed_significant_date(1i)"
    ).values.all?(&:present?) && @project.significant_date_provisional? == false
  end

  def in_progress?
    attributes.values.any?(&:present?) || @project.significant_date_provisional? == false
  end
end
