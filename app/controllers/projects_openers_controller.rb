class ProjectsOpenersController < ApplicationController
  def openers
    authorize Project

    @projects = ProjectsFetcher.new.sorted_openers(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end
end
