class All::Statistics::ProjectsController < ApplicationController
  def index
    @project_statistics = ProjectStatistics.new
  end
end
