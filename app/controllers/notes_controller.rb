class NotesController < ApplicationController
  before_action :find_project
  before_action :find_project_level_notes, only: :index
  after_action :verify_authorized, except: :index

  def new
    authorize @project, :new_note?

    @note = Note.new(project: @project, user_id:, task_identifier: params[:task_identifier])
  end

  def create
    authorize @project, :new_note?

    @note = Note.new(project: @project, user_id:, **note_params)

    if @note.valid?
      @note.save

      redirect_to(return_path, notice: I18n.t("note.create.success"))
    else
      render :new
    end
  end

  def edit
    @note = Note.find(params[:id])
    authorize @note
  end

  def update
    @note = Note.find(params[:id])
    authorize @note

    @note.assign_attributes(note_params)

    if @note.valid?
      @note.save
      redirect_to return_path, notice: I18n.t("note.update.success")
    else
      render :edit
    end
  end

  def destroy
    @note = Note.find(params[:id])
    authorize @note

    @note.destroy

    redirect_to return_path, notice: I18n.t("note.destroy.success")
  end

  def confirm_destroy
    @note = Note.find(params[:note_id])
    authorize @note
  end

  private def return_path
    return task_list_path if @note.task_level_note?

    project_notes_path(@project)
  end
  helper_method :return_path

  private def task_list_path
    case @project.task_list_name.to_sym
    when :conversion_voluntary_task_list then conversions_voluntary_project_edit_task_path(@project, @note.task_identifier)
    when :conversion_involuntary_task_list then conversions_involuntary_project_edit_task_path(@project, @note.task_identifier)
    end
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_project_level_notes
    @notes = Note.project_level_notes(@project).includes([:user, :project])
  end

  private def note_params
    params.require(:note).permit(:body, :task_identifier)
  end
end
