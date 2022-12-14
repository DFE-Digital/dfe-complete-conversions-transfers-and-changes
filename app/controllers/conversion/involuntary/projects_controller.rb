class Conversion::Involuntary::ProjectsController < Conversion::ProjectsController
  def create
    @note = Note.new(**note_params, user_id: user_id)
    @project = Conversion::Project.new(**project_params, regional_delivery_officer_id: user_id, notes_attributes: [@note.attributes])

    authorize @project

    if @project.valid?
      ActiveRecord::Base.transaction do
        @project.save
        Conversion::Involuntary::Details.create(project: @project)
        TaskListCreator.new.call(@project, workflow_root: Conversion::Involuntary::Details::WORKFLOW_PATH)
      end

      redirect_to project_path(@project), notice: I18n.t("conversion_project.involuntary.create.success")

    else
      render :new
    end
  end
end
