class Conversion::Task::ConditionsMetTaskForm < BaseTaskForm
  attribute :confirm_all_conditions_met, :boolean

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project
    super(@tasks_data, @user)
    self.confirm_all_conditions_met = @project.all_conditions_met
  end

  def save
    @project.update(all_conditions_met: confirm_all_conditions_met)
  end
end
