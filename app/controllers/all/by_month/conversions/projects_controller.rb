class All::ByMonth::Conversions::ProjectsController < ApplicationController
  def date_range
    authorize Project, :index?

    @from_date = "#{from_year}-#{from_month}-1"
    @to_date = "#{to_year}-#{to_month}-1"
    return redirect_if_dates_incorrect if Date.parse(@to_date) < Date.parse(@from_date)

    @from_month = from_month
    @from_year = from_year
    @to_month = to_month
    @to_year = to_year

    @pager, @projects = pagy_array(ByMonthProjectFetcherService.new.conversion_projects_by_date_range(@from_date, @to_date))
  end

  def date_range_select
    authorize Project, :index?

    return redirect_if_dates_incorrect if Date.parse(to_date) < Date.parse(from_date)

    from_year, from_month = from_date.split("-")
    to_year, to_month = to_date.split("-")

    redirect_to action: "date_range", from_month: from_month, from_year: from_year, to_month: to_month, to_year: to_year
  end

  def date_range_this_month
    authorize Project, :index?

    from_month = Date.today.month
    from_year = Date.today.year
    to_month = Date.today.month
    to_year = Date.today.year
    redirect_to action: "date_range", from_month: from_month, from_year: from_year, to_month: to_month, to_year: to_year
  end

  private def redirect_if_dates_incorrect
    redirect_to date_range_this_month_all_by_month_conversions_projects_path, alert: I18n.t("project.date_range.date_form.from_date_before_to_date")
  end

  private def from_month
    params[:from_month]
  end

  private def from_year
    params[:from_year]
  end

  private def to_month
    params[:to_month]
  end

  private def to_year
    params[:to_year]
  end

  private def from_date
    params[:from_date].to_s
  end

  private def to_date
    params[:to_date].to_s
  end
end
