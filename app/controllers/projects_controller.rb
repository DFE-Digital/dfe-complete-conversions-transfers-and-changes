class ProjectsController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  DEFAULT_WORKFLOW_ROOT = Rails.root.join("app", "workflows", "lists", "conversion").freeze

  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project))
  end

  def show
    @project = Project.includes(sections: [:tasks]).find(params[:id])
    authorize @project
  end

  def new
    authorize Project
    @project = Project.new
  end

  def create
    @note = Note.new(**note_params, user_id: user_id)
    @project = Project.new(**project_params, regional_delivery_officer_id: user_id, notes_attributes: [@note.attributes])

    authorize @project

    if @project.valid?
      ActiveRecord::Base.transaction do
        @project.save
        TaskListCreator.new.call(@project, workflow_root: DEFAULT_WORKFLOW_ROOT)
      end

      notify_team_leaders

      redirect_to project_path(@project), notice: I18n.t("project.create.success")
    else
      render :new
    end
  end

  private def notify_team_leaders
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_project_created(team_leader, @project).deliver_later
    end
  end

  private def project_params
    params.require(:project).permit(
      :urn,
      :incoming_trust_ukprn,
      :target_completion_date,
      :advisory_board_date,
      :advisory_board_conditions,
      :establishment_sharepoint_link,
      :trust_sharepoint_link
    )
  end

  private def note_params
    params.require(:project).require(:note).permit(:body)
  end
end
