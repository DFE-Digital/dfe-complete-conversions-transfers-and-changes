class NotesController < ApplicationController
  before_action :find_project
  before_action :find_notes, only: :index
  after_action :verify_authorized

  def index
    authorize Note
  end

  def new
    authorize Note
    @note = Note.new(project: @project, user_id:)
  end

  def create
    authorize Note
    @note = Note.new(project: @project, user_id:, **note_params)

    if @note.valid?
      @note.save

      redirect_to project_notes_path(@project), notice: I18n.t("note.create.success")
    else
      render :new
    end
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_notes
    @notes = Note.includes([:user]).where(project: @project)
  end

  private def note_params
    params.require(:note).permit(:body)
  end
end
