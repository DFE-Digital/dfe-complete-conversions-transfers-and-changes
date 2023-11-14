class Transfers::ProjectsController < ApplicationController
  def new
    authorize Transfer::Project
    @project = Transfer::CreateProjectForm.new
  end

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

  def edit
    authorize project
    @project_form = Transfer::EditProjectSharepointLinkForm.new(project: project)
  end

  def update
    authorize project
    @project_form = Transfer::EditProjectSharepointLinkForm.new(project: project, args: sharepoint_link_params)

    if @project_form.save
      redirect_to project_information_path(project), notice: I18n.t("project.update.success")
    else
      render :edit
    end
  end

  private def project
    @project ||= Project.find(params[:id])
  end

  private def sharepoint_link_params
    params.require(:transfer_edit_project_sharepoint_link_form).permit(
      :establishment_sharepoint_link,
      :incoming_trust_sharepoint_link,
      :outgoing_trust_sharepoint_link
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
      :financial_safeguarding_governance_issues
    )
  end
end
