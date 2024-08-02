class Conversions::ProjectsController < ProjectsController
  def new
    authorize Conversion::Project
    @project = Conversion::CreateProjectForm.new
  end

  alias_method :new_mat, :new

  def create
    authorize Conversion::Project
    @project = Conversion::CreateProjectForm.new(**project_params, user: current_user)

    if @project.valid?(:existing_trust)
      @created_project = @project.save(:existing_trust)

      if project_params["assigned_to_regional_caseworker_team"].eql?("true")
        @project = @created_project
        render "created"
      else
        redirect_to project_path(@created_project), notice: I18n.t("conversion_project.create.assigned_to_regional_delivery_officer.html")
      end
    else
      render :new
    end
  end

  def create_mat
    authorize Conversion::Project
    @project = Conversion::CreateProjectForm.new(**project_params, user: current_user)

    if @project.valid?(:form_a_mat)
      @created_project = @project.save(:form_a_mat)

      if project_params["assigned_to_regional_caseworker_team"].eql?("true")
        @project = @created_project
        render "created"
      else
        redirect_to project_path(@created_project), notice: I18n.t("conversion_project.create.assigned_to_regional_delivery_officer.html")
      end
    else
      render :new_mat
    end
  end

  def edit
    authorize project
    @project_form = Conversion::EditProjectForm.new_from_project(project, current_user)
  end

  def update
    authorize project
    @project_form = Conversion::EditProjectForm.new_from_project(project, current_user)

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
    params.require(:conversion_edit_project_form).permit(
      :establishment_sharepoint_link,
      :incoming_trust_sharepoint_link,
      :incoming_trust_ukprn,
      :group_id,
      :advisory_board_date,
      :advisory_board_conditions,
      :directive_academy_order,
      :two_requires_improvement,
      :assigned_to_regional_caseworker_team,
      :handover_note_body
    )
  end

  private def project_params
    params.require(:conversion_create_project_form).permit(
      :urn,
      :incoming_trust_ukprn,
      :provisional_conversion_date,
      :advisory_board_date,
      :advisory_board_conditions,
      :establishment_sharepoint_link,
      :incoming_trust_sharepoint_link,
      :handover_note_body,
      :assigned_to_regional_caseworker_team,
      :directive_academy_order,
      :two_requires_improvement,
      :new_trust_name,
      :new_trust_reference_number,
      :group_id
    )
  end
end
