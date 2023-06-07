class All::Opening::ProjectsController < ApplicationController
  def confirmed
    authorize Project, :index?

    @projects = ProjectsFetcher.new.sorted_openers(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
  end

  def revised
    authorize Project, :index?

    @projects = Project.conversion_date_revised_from(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
  end

  def download_csv
    authorize Project, :index?

    @projects = ProjectsFetcher.new.sorted_openers(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
    @month = month
    @year = year

    @csv = OpeningProjectsCsvExporter.new(@projects).call

    send_data @csv, filename: "opener.csv", type: :csv, disposition: "attachment"
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end
end
