class Transfers::ProjectsController < ApplicationController
  def new
    authorize Transfer::Project
    @project = Transfer::CreateProjectForm.new
  end

  alias_method :new_mat, :new

  def create
    authorize Transfer::Project
    @project = Transfer::CreateProjectForm.new(**project_params, user: current_user)

    if @project.valid?
      @created_project = @project.save

      redirect_to project_path(@created_project), notice: I18n.t("transfer_project.created.success")
    else
      render :new
    end
  end

  def create_mat
    authorize Transfer::Project
    @project = Transfer::CreateProjectForm.new(**project_params, user: current_user)

    if @project.valid?
      @created_project = @project.save

      redirect_to project_path(@created_project), notice: I18n.t("transfer_project.form_a_mat.created.success")
    else
      render :new_mat
    end
  end

  def edit
    authorize project
    @project_form = Transfer::EditProjectForm.new_from_project(project)
  end

  def update
    authorize project
    @project_form = Transfer::EditProjectForm.new_from_project(project)

    if @project_form.update(edit_project_params)
      redirect_to project_information_path(project), notice: I18n.t("project.update.success")
    else
      render :edit
    end
  end

  private def project
    @project ||= Project.find(params[:id])
  end

  private def edit_project_params
    params.require(:transfer_edit_project_form).permit(
      :establishment_sharepoint_link,
      :incoming_trust_sharepoint_link,
      :outgoing_trust_sharepoint_link,
      :outgoing_trust_ukprn
    )
  end

  private def project_params
    params.require(:transfer_create_project_form).permit(
      :urn,
      :incoming_trust_ukprn,
      :outgoing_trust_ukprn,
      :establishment_sharepoint_link,
      :advisory_board_date,
      :advisory_board_conditions,
      :provisional_transfer_date,
      :incoming_trust_sharepoint_link,
      :outgoing_trust_sharepoint_link,
      :assigned_to_regional_caseworker_team,
      :handover_note_body,
      :two_requires_improvement,
      :inadequate_ofsted,
      :financial_safeguarding_governance_issues,
      :outgoing_trust_to_close,
      :new_trust_name,
      :new_trust_reference_number
    )
  end
end
