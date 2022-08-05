class NotesController < ApplicationController
  before_action :find_project

  def index
    @note = Note.new(project: @project, user_id:)
  end

  def create
    @note = Note.new(project: @project, user_id:, **note_params)

    if @note.valid?
      @note.save

      redirect_to project_notes_path(@project), notice: I18n.t("note.create.success")
    else
      render :index
    end
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def note_params
    params.require(:note).permit(:body)
  end
end
