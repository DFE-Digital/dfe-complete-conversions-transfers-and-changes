class DateHistory::Reasons::EarlierController < ApplicationController
  include Projectable

  def create
    authorize(@project, :change_significant_date?)
    @form = NewDateHistoryForm.new(project: @project, user: current_user)
    @reasons_form = DateHistory::Reasons::NewEarlierForm.new(**date_history_params, project: @project, user: current_user)

    if @reasons_form.save
      @project.reload
      render "date_history/confirm_new"
    else
      render "date_history/reasons/earlier/new"
    end
  end

  private def date_history_params
    params.require(:date_history_reasons_new_earlier_form)
      .permit(
        :revised_date,
        :progressing_faster_than_expected,
        :progressing_faster_than_expected_note,
        :correcting_an_error,
        :correcting_an_error_note
      )
  end
end
