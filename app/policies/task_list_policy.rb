class TaskListPolicy
  attr_reader :user, :task_list

  def initialize(user, task_list)
    @user = user
    @task_list = task_list
    @project = task_list.project
  end

  def edit?
    true
  end

  def update?
    return false if @project.completed?

    @task_list.project.assigned_to == @user
  end
end
