class DaoRevocationsController < ApplicationController
  include Projectable

  before_action :redirect_if_not_revokable
  before_action :redirect_if_project_revoked
  before_action :redirect_if_invalid_step, only: %i[step update_step change_step update_change_step]

  def start
    authorize @project, :dao_revocation?
  end

  def step
    authorize @project, :dao_revocation?
    if requested_step.eql?(DaoRevocationSteppedForm.first_step)
      delete_session
    end

    @step_form = DaoRevocationSteppedForm.new

    render requested_step.to_s
  end

  def update_step
    authorize @project, :dao_revocation?
    @step_form = DaoRevocationSteppedForm.new(get_session)
    @step_form.assign_attributes(dao_revocations_params.to_h)

    if @step_form.valid?(requested_step)
      set_session(@step_form.to_h)

      if requested_step.eql?(DaoRevocationSteppedForm.last_step)
        redirect_to project_dao_revocation_check_path(@project)
      else
        redirect_to next_step
      end
    else
      render requested_step.to_s
    end
  end

  def change_step
    authorize @project, :dao_revocation?
    @step_form = DaoRevocationSteppedForm.new(get_session)

    render "change_#{requested_step}"
  end

  def update_change_step
    authorize @project, :dao_revocation?
    @step_form = DaoRevocationSteppedForm.new(get_session)
    @step_form.assign_attributes(dao_revocations_params.to_h)

    if @step_form.valid?(requested_step)
      set_session(@step_form.to_h)

      redirect_to project_dao_revocation_check_path(@project)
    else
      render "change_#{requested_step}"
    end
  end

  def check
    authorize @project, :dao_revocation?
    @step_form = DaoRevocationSteppedForm.new(get_session)

    redirect_to project_dao_revocation_start_path(@project) unless @step_form.checkable?
  end

  def save
    authorize @project, :dao_revocation?
    @step_form = DaoRevocationSteppedForm.new(get_session)

    if @step_form.save_to_project(@project)
      delete_session
      redirect_to project_path(@project), notice: I18n.t("dao_revocations.check.successful")
    else
      render :check
    end
  end

  private def set_session(values)
    session[session_key] = values
  end

  private def get_session
    session[session_key]
  end

  private def delete_session
    session.delete(session_key)
  end

  private def session_key
    "dao_revocation_#{@project.id}"
  end

  private def dao_revocations_params
    params
      .require(:dao_revocation_stepped_form)
      .permit(
        :reason_school_closed,
        :reason_school_rating_improved,
        :reason_safeguarding_addressed,
        :minister_name,
        :date_of_decision,
        :confirm_minister_approved,
        :confirm_letter_sent,
        :confirm_letter_saved
      )
  end

  private def requested_step
    params["step"].to_sym
  end

  private def steps
    DaoRevocationSteppedForm.steps
  end

  private def next_step
    next_index = steps.find_index(requested_step) + 1

    project_dao_revocation_step_path(@project, steps[next_index])
  end

  private def redirect_if_not_revokable
    redirect_to project_path(@project), notice: I18n.t("dao_revocations.project_not_revokable") unless @project.dao_revokable?
  end

  private def redirect_if_project_revoked
    redirect_to project_path(@project) if @project.dao_revocation.present?
  end

  private def redirect_if_invalid_step
    not_found_error unless steps.include?(requested_step)
  end
end
