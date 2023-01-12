class Conversions::Voluntary::ProjectsController < Conversions::ProjectsController
  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.conversions_voluntary.open.includes(:details)))

    EstablishmentsFetcher.new.call(@projects)
    IncomingTrustsFetcher.new.call(@projects)

    render "/conversions/voluntary/index"
  end

  def show
    @project = Project.conversions_voluntary.find(params[:id])
    authorize @project
    redirect_to conversions_voluntary_project_task_list_path(@project)
  end

  def new
    authorize Conversion::Project
    @project = Conversion::Voluntary::CreateProjectForm.new
  end

  def create
    authorize Conversion::Project
    @project = Conversion::Voluntary::CreateProjectForm.new(**project_params, user: current_user)

    if @project.valid?
      @created_project = @project.save

      redirect_to project_path(@created_project), notice: I18n.t("conversion_project.voluntary.create.success")
    else
      render :new
    end
  end

  private def project_params
    params.require(:conversion_voluntary_create_project_form).permit(
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
