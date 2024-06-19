class DateHistoryController < ApplicationController
  include Projectable

  def index
    dates = @project.date_history.includes([:user, reasons: [:note]]).order(created_at: :desc)
    @dates = dates.map { |date| SignificantDatePresenter.new(date) }
  end

  def new
    authorize(@project, :change_significant_date?)
    @form = NewDateHistoryForm.new
  end

  def create
    authorize(@project, :change_significant_date?)
    @form = NewDateHistoryForm.new(**date_history_params, project: @project, user: current_user)

    if @form.valid?
      if revised_date_earlier?
        @reasons_form = DateHistory::Reasons::NewEarlierForm.new(@form.attributes)
        render "date_history/reasons/earlier/new"
      else
        @reasons_form = DateHistory::Reasons::NewLaterForm.new(@form.attributes)
        render "date_history/reasons/later/new"
      end
    else
      render :new
    end
  end

  private def date_history_params
    params.require(:new_date_history_form).permit(:revised_date, :note_body)
  end

  private def revised_date_earlier?
    @form.revised_date < @project.significant_date
  end
end
