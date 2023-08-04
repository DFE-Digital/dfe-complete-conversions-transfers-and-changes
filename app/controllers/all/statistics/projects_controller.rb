class All::Statistics::ProjectsController < ApplicationController
  def index
    @project_statistics = Statistics::ProjectStatistics.new
  end
end
