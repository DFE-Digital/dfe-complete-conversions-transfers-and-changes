class All::Statistics::StatisticsController < ApplicationController
  def index
    @project_statistics = Statistics::ProjectStatistics.new
    @user_statistics = Statistics::UserStatistics.new
  end
end
