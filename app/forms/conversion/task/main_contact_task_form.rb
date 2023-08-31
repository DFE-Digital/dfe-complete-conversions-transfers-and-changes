class Conversion::Task::MainContactTaskForm < ::BaseTaskForm
  attribute :main_contact_id, :string

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = @tasks_data.project

    super(@tasks_data, @user)
    self.main_contact_id = @project.main_contact_id
  end

  def save
    @project.update!(main_contact_id: main_contact_id)
  end

  private def completed?
    @project.main_contact_id.present?
  end
end
