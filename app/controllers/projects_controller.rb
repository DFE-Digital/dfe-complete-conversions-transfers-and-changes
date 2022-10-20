require 'async'
require 'async/barrier'
require 'async/semaphore'
require 'async/http/internet'

class ProjectsController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index
  after_action :print_time, only: :index

  DEFAULT_WORKFLOW_ROOT = Rails.root.join("app", "workflows", "lists", "conversion").freeze

  def index
    @start_time = Time.now
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project))

    fetch_establishments(@projects)
  end

  def fetch_establishments(projects)
    Async do
      internet = Async::HTTP::Internet.new
      barrier = Async::Barrier.new
      semaphore = Async::Semaphore.new(2, parent: barrier)
      headers = {
        "Content-Type": "application/json",
        ApiKey: ENV["ACADEMIES_API_KEY"]
      }

      projects.each do |project|
        semaphore.async do
          establishment_response = internet.get("#{ENV["ACADEMIES_API_HOST"]}/establishment/urn/#{project.urn}", headers)

          project.establishment = AcademiesApi::Establishment.new.from_json(establishment_response.read)
        end

        semaphore.async do
          trust_response = internet.get("#{ENV["ACADEMIES_API_HOST"]}/v2/trust/#{project.incoming_trust_ukprn}", headers)

          project.incoming_trust = AcademiesApi::Trust.new.from_json(trust_response.read)
        end
      end

      barrier.wait
    ensure
      internet&.close
    end
  end

  def print_time
    end_time = Time.now

    p "Seconds: #{end_time.to_i - @start_time.to_i}"
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
      @project.save
      TaskListCreator.new.call(@project, workflow_root: DEFAULT_WORKFLOW_ROOT)
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
      :establishment_sharepoint_link
    )
  end

  private def note_params
    params.require(:project).require(:note).permit(:body)
  end
end
