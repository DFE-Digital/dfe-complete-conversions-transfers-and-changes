class Conversions::ProjectsController < ProjectsController
  def index
    authorize Project
    @pagy, @projects = pagy(Project.conversions.in_progress)

    EstablishmentsFetcherService.new(@projects).call!
    TrustsFetcherService.new(@projects).call!

    render "/conversions/index"
  end

  def new
    authorize Conversion::Project
    @project = Conversion::CreateProjectForm.new
  end

  def create
    authorize Conversion::Project
    @project = Conversion::CreateProjectForm.new(**project_params, user: current_user)

    if @project.valid?
      @created_project = @project.save

      if project_params["assigned_to_regional_caseworker_team"].eql?("true")
        @project = @created_project
        render "created"
      else
        redirect_to project_path(@created_project), notice: I18n.t("conversion_project.voluntary.create.assigned_to_regional_delivery_officer.html")
      end
    else
      render :new
    end
  end

  private def project_params
    params.require(:conversion_create_project_form).permit(
      :urn,
      :incoming_trust_ukprn,
      :provisional_conversion_date,
      :advisory_board_date,
      :advisory_board_conditions,
      :establishment_sharepoint_link,
      :trust_sharepoint_link,
      :handover_note_body,
      :assigned_to_regional_caseworker_team,
      :directive_academy_order,
      :two_requires_improvement
    )
  end
end
