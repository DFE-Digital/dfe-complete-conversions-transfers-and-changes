class All::ByMonth::ProjectsController < ApplicationController
  def confirmed
    authorize Project, :index?

    @projects = ByMonthProjectFetcherService.new.confirmed(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
    @month = month
    @year = year
  end

  def confirmed_index
    authorize Project, :index?

    @months = []
    (1..6).each do |i|
      date = Date.today + i.month
      @months << OpenStruct.new(
        date: date,
        transfers: ByMonthProjectFetcherService.new.confirmed_transfers(date.month, date.year).count,
        conversions: ByMonthProjectFetcherService.new.confirmed_conversions(date.month, date.year).count
      )
    end
    @months
  end

  def revised
    authorize Project, :index?

    @projects = ByMonthProjectFetcherService.new.revised(month, year)
    @date = "#{Date::MONTHNAMES[month.to_i]} #{year}"
    @month = month
    @year = year
  end

  def revised_index
    authorize Project, :index?

    @months = []
    (1..6).each do |i|
      date = Date.today + i.month
      @months << OpenStruct.new(
        date: date,
        transfers: ByMonthProjectFetcherService.new.revised_transfers(date.month, date.year).count,
        conversions: ByMonthProjectFetcherService.new.revised_conversions(date.month, date.year).count
      )
    end
    @months
  end

  private def month
    params[:month]
  end

  private def year
    params[:year]
  end
end
