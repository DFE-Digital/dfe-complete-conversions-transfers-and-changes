class Conversion::ProjectsController < ProjectsController
  def new
    authorize Conversion::Project
    @project = Conversion::Project.new
  end

  private def project_params
    params.require(:conversion_project).permit(
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
end
