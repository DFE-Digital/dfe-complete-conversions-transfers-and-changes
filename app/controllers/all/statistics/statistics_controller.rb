class All::Statistics::StatisticsController < ApplicationController
  def index
    @project_statistics = Statistics::ProjectStatistics.new
  end
end
