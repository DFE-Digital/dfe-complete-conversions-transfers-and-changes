class Conversion::Voluntary::ProjectsController < Conversion::ProjectsController
  def create
    @note = Note.new(**note_params, user_id: user_id)
    @project = Conversion::Project.new(**project_params, regional_delivery_officer_id: user_id, notes_attributes: [@note.attributes])

    authorize @project

    if @project.valid?
      ActiveRecord::Base.transaction do
        @project.save
        Conversion::Voluntary::Details.create(project: @project)
        TaskListCreator.new.call(@project, workflow_root: Conversion::Voluntary::Details::WORKFLOW_PATH)
      end

      notify_team_leaders

      redirect_to project_path(@project), notice: I18n.t("project.create.success")
    else
      render :new
    end
  end
end
