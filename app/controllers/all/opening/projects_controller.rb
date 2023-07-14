class All::Opening::ProjectsController < ApplicationController
  def confirmed
    authorize Project, :index?

    @projects = ByMonthProjectFetcherService.new.sorted_openers(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
  end

  def confirmed_next_month
    month = Date.today.next_month.month
    year = Date.today.next_month.year
    redirect_to action: "confirmed", month: month, year: year
  end

  def revised
    authorize Project, :index?

    @projects = Conversion::Project.conversion_date_revised_from(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
  end

  def revised_next_month
    month = Date.today.next_month.month
    year = Date.today.next_month.year
    redirect_to action: "revised", month: month, year: year
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end
end
