class Projects::Conversions::Tasks::StakeholderKickOffController < Projects::Conversions::Tasks::BaseController
  def edit
    @task = Projects::Conversions::Tasks::StakeholderKickOffTaskForm.new(@task_list)
    find_task_notes
  end

  def update
    @task = Projects::Conversions::Tasks::StakeholderKickOffTaskForm.new(@task_list)
    find_task_notes

    @task.assign_attributes(task_params)

    if @task.valid?
      @task.save
      redirect_to action: :edit
    else
      render :edit
    end
  end

  private def task_params
    params.fetch(task_param_key, {}).permit @task.attributes.keys
  end
end
