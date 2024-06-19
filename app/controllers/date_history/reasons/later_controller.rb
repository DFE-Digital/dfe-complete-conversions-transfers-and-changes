class DateHistory::Reasons::LaterController < ApplicationController
  include Projectable

  def create
    authorize(@project, :change_significant_date?)
    @form = NewDateHistoryForm.new(project: @project, user: current_user)
    @reasons_form = DateHistory::Reasons::NewLaterForm.new(**date_history_params, project: @project, user: current_user)

    if @reasons_form.save
      @project.reload
      render "date_history/confirm_new"
    else
      render "date_history/reasons/later/new"
    end
  end

  private def date_history_params
    params.require(:date_history_reasons_new_later_form).permit(:revised_date, reasons_params)
  end

  private def reasons_params
    DateHistory::Reasons::NewLaterForm::ALL_REASONS_LIST.map do |reason|
      [reason, :"#{reason}_note"]
    end
  end
end
