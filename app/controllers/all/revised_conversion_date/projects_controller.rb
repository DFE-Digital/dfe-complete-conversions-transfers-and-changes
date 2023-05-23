class All::RevisedConversionDate::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?

    @projects = Project.conversion_date_revised_from(month, year)
    @date = "#{month_name(month)} #{year}"
  end

  private def month_name(month)
    Date::MONTHNAMES[month]
  end

  private def month
    params[:month].to_i
  end

  private def year
    params[:year].to_i
  end
end
