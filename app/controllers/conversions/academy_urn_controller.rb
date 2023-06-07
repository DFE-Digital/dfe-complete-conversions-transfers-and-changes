class Conversions::AcademyUrnController < ApplicationController
  rescue_from Api::AcademiesApi::Client::NotFoundError, with: :not_found_error

  def edit
    @project = Project.find(params[:project_id])
    authorize @project
  end

  def check
    @project = Project.find(params[:project_id])
    authorize @project

    if academy_urn.blank?
      @project.errors.add(:academy_urn, :blank)
      return render :edit
    end

    @project.assign_attributes(academy_urn: academy_urn)
    unless @project.valid?
      @project.errors.add(:academy_urn, :invalid_urn)
      return render :edit
    end

    result = fetch_academy_details(academy_urn)
    @academy_urn = academy_urn
    @establishment = result

    render "confirm"
  end

  def update_academy_urn
    @project = Project.find(params[:project_id])
    authorize @project

    @project.update(academy_urn: academy_urn)
    redirect_to without_academy_urn_service_support_projects_path, notice: t("project.academy_urn.confirm.success", academy_urn: academy_urn, urn: @project.urn, school_name: @project.establishment.name)
  end

  def not_found_error
    @academy_urn = academy_urn
    render "not_found"
  end

  private def project_params
    params.require(:conversion_project).permit(:academy_urn)
  end

  private def fetch_academy_details(academy_urn)
    client = Api::AcademiesApi::Client.new
    result = client.get_establishment(academy_urn.to_i)
    raise result.error if result.error
    result.object
  end

  private def academy_urn
    project_params[:academy_urn]
  end
end
