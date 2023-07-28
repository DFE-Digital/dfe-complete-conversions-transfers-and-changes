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

  private def project_params
    params.require(:transfer_create_project_form).permit(
      :urn,
      :incoming_trust_ukprn,
      :outgoing_trust_ukprn,
      :establishment_sharepoint_link,
      :advisory_board_date,
      :provisional_transfer_date,
      :trust_sharepoint_link
    )
  end
end
