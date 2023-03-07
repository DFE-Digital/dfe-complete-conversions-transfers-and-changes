class ProjectsOpenersController < ApplicationController
  def openers
    authorize Project

    @projects = Project.opening_by_month_year(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end
end
