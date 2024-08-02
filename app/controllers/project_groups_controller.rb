class ProjectGroupsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize Project, :index?
  end
end
