class DateHistoriesController < ApplicationController
  include Projectable

  def index
    @dates = @project.date_history.includes([note: [:user]]).order(created_at: :desc)
  end

  def new
    authorize(@project, :change_significant_date?)
    @form = NewDateHistoryForm.new
  end

  def create
    authorize(@project, :change_significant_date?)
    @form = NewDateHistoryForm.new(**new_date_history_form, project: @project, user: current_user)

    if @form.save
      @project.reload
      render "confirm_new"
    else
      render :new
    end
  end

  private def new_date_history_form
    params.require(:new_date_history_form).permit(:revised_date, :note_body)
  end
end
