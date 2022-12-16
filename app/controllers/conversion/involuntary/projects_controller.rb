class Conversion::Involuntary::ProjectsController < Conversion::ProjectsController
  def new
    authorize Conversion::Project
    @project = Conversion::Involuntary::CreateProjectForm.new
  end

  private def project_params
    params.require(:conversion_involuntary_create_project_form).permit(
      :urn,
      :incoming_trust_ukprn,
      :provisional_conversion_date,
      :advisory_board_date,
      :advisory_board_conditions,
      :establishment_sharepoint_link,
      :trust_sharepoint_link,
      :note_body
    )
  end

  def create
    authorize Conversion::Project
    @project = Conversion::Involuntary::CreateProjectForm.new(**project_params, user: current_user)

    if @project.valid?
      @created_project = @project.save

      redirect_to project_path(@created_project), notice: I18n.t("conversion_project.involuntary.create.success")
    else
      render :new
    end
  end
end
