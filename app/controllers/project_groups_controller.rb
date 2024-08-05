class ProjectGroupsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize Project, :index?

    @pager, @groups = pagy(ProjectGroup.all.includes(:projects).order(group_identifier: :desc))
  end
end
