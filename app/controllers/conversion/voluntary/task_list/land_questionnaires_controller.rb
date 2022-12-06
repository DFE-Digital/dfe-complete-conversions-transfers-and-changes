class Conversion::Voluntary::TaskList::LandQuestionnairesController < Conversion::Voluntary::TaskList::BaseTasksController
  def edit
    @project = Project.find(params[:project_id])
    # @land_questionnaire = @project.task_list.land_questionnaire
    # Why doesn't this work? >:(

    @land_questionnaire = Conversion::Voluntary::TaskList.find_by(project: @project).land_questionnaire
    # @tasks = Conversion::Voluntary::TaskList.find_by(project: @project).tasks
  end

  def update
    @land_questionnaire = Conversion::Voluntary::LandQuestionnaire.new(land_questionnaire_params)
    @project = Project.find(params[:project_id])
    @task_list = Conversion::Voluntary::TaskList.find_by(project: @project)

    if @land_questionnaire.valid?
      @task_list.update!(land_questionnaire: @land_questionnaire)

      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  private

  def task_list
    Conversion::Voluntary::TaskList.find_by(project: @project)
  end

  def land_questionnaire_params
    params.require(:conversion_voluntary_land_questionnaire).permit \
      :received, :cleared, :signed_by_solicitor, :saved_in_school_sharepoint
  end
end
