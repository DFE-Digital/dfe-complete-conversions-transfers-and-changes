class ProjectGroupsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize Project, :index?

    @pager, @groups = pagy(ProjectGroup.all.includes(:projects).order(group_identifier: :desc))

    ProjectGroupPreFetchingService.new(@groups).pre_fetch!
  end

  def show
    authorize Project, :index?

    @project_group = ProjectGroup.find(params[:id])

    projects = @project_group.projects.includes([:local_authority])
    AcademiesApiPreFetcherService.new.call!(projects)

    @grouped_projects = projects.sort_by { |project| project.establishment.name }
  end
end
