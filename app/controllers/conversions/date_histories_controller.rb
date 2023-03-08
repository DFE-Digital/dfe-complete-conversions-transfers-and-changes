class Conversions::DateHistoriesController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    authorize(@project, :change_conversion_date?)
    @form = Conversion::NewDateHistoryForm.new
  end

  def create
    @project = Project.find(params[:project_id])
    authorize(@project, :change_conversion_date?)
    @form = Conversion::NewDateHistoryForm.new(**conversion_date_history_params, project_id: @project.id, user_id: current_user.id)

    if @form.save
      render "confirm_new"
    else
      render :new
    end
  end

  private def conversion_date_history_params
    params.require(:conversion_new_date_history_form).permit(:revised_date, :note_body)
  end
end
