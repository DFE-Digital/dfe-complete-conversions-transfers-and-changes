class Conversion::ProjectsController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  DEFAULT_WORKFLOW_ROOT = Rails.root.join("app", "workflows", "lists", "conversion").freeze

  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.open))
  end

  def completed
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.completed))
  end

  def show
    @project = Converison::Project.includes(sections: [:tasks]).find(params[:id])
    authorize @project, policy_class: ProjectPolicy
  end

  def new
    authorize Project
    @project = Conversion::Project.new
  end

  def create
    binding.pry
    @note = Note.new(**note_params, user_id: user_id)
    @project = Conversion::Project.new(**project_params, regional_delivery_officer_id: user_id, notes_attributes: [@note.attributes])

    authorize @project, policy_class: ProjectPolicy

    if @project.valid?
      ActiveRecord::Base.transaction do
        @project.save
        Conversion::Voluntary::Details.create(project: @project)
        TaskListCreator.new.call(@project, workflow_root: Conversion::Voluntary::Details::WORKFLOW_ROOT)
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
    params.require(:conversion_project).permit(
      :urn,
      :incoming_trust_ukprn,
      :provisional_conversion_date,
      :advisory_board_date,
      :advisory_board_conditions,
      :establishment_sharepoint_link,
      :trust_sharepoint_link,
    )
  end

  private def note_params
    params.require(:conversion_project).require(:note).permit(:body)
  end
end
