class Conversion::Voluntary::TaskList::LandQuestionnairesController < Conversion::Voluntary::TaskList::BaseTasksController
  def edit
    @land_questionnaire = @task_list.land_questionnaire
  end

  def update
    @land_questionnaire = Conversion::Voluntary::LandQuestionnaire.new(land_questionnaire_params)

    if @land_questionnaire.valid?
      @task_list.update!(land_questionnaire: @land_questionnaire)

      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  private

  def land_questionnaire_params
    params.require(:conversion_voluntary_land_questionnaire).permit \
      :received, :cleared, :signed_by_solicitor, :saved_in_school_sharepoint
  end
end
