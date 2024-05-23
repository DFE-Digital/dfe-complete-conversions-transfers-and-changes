class Transfer::Task::ConditionsMetTaskForm < BaseTaskForm
  attribute :confirm_all_conditions_met, :boolean
  attribute :check_any_information_changed, :boolean
  attribute :baseline_sheet_approved, :boolean

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    super(@tasks_data, @user)
    self.confirm_all_conditions_met = @project.all_conditions_met
  end

  def save
    @tasks_data.assign_attributes(
      conditions_met_check_any_information_changed: check_any_information_changed,
      conditions_met_baseline_sheet_approved: baseline_sheet_approved
    )
    @tasks_data.save!
    @project.update!(authority_to_proceed: confirm_all_conditions_met)
  end
end
