class All::ByMonth::Conversions::ProjectsController < ApplicationController
  def date_range
    authorize Project, :index?
    @from_date = Date.new(from_year.to_i, from_month.to_i).at_beginning_of_month
    @to_date = Date.new(to_year.to_i, to_month.to_i).at_end_of_month

    redirect_if_dates_incorrect if @to_date < @from_date

    get_projects_for_date_range
  end

  def date_range_select
    authorize Project, :index?
    @from_date = Date.parse(from_date).at_beginning_of_month
    @to_date = Date.parse(to_date).at_end_of_month

    return redirect_if_dates_incorrect if @to_date < @from_date

    get_projects_for_date_range

    render :date_range
  end

  def date_range_this_month
    authorize Project, :index?

    @from_date = Date.today.at_beginning_of_month
    @to_date = Date.today.at_end_of_month

    get_projects_for_date_range

    render :date_range
  end

  def single_month
    authorize Project, :index?

    @from_date = Date.new(year.to_i, month.to_i).at_beginning_of_month
    @to_date = @from_date

    get_projects_for_date_range
  end

  def next_month
    authorize Project, :index?

    redirect_to action: "single_month",
      month: (Date.today + 1.month).month, year: (Date.today + 1.month).year
  end

  private def get_projects_for_date_range
    @pager, @projects = pagy_array(
      ByMonthProjectFetcherService.new.conversion_projects_by_date_range(@from_date, @to_date)
    )
  end

  private def redirect_if_dates_incorrect
    redirect_to date_range_this_month_all_by_month_conversions_projects_path,
      alert: I18n.t("project.date_range.date_form.from_date_before_to_date")
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

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end
end
