class All::Openers::ProjectsController < ApplicationController
  def index
    authorize Project, :index?

    @projects = ProjectsFetcher.new.sorted_openers(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
    @month = month
    @year = year
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end
end
