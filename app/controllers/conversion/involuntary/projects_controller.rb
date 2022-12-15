class Conversion::Involuntary::ProjectsController < Conversion::ProjectsController
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
