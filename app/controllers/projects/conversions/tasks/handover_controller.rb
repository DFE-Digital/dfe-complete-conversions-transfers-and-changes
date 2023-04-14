class Projects::Conversions::Tasks::HandoverController < Projects::Conversions::Tasks::BaseController
  def edit
    @task = Projects::Conversions::Tasks::HandoverTaskForm.new(@task_list)
  end

  def update
    @task = Projects::Conversions::Tasks::HandoverTaskForm.new(@task_list)

    @task.assign_attributes(task_params)

    if @task.valid?
      @task.save
    end

    redirect_to action: :edit
  end

  private def task_params
    params.fetch(task_param_key, {}).permit @task.attributes.keys
  end
end
