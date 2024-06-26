module DateRangable
  extend ActiveSupport::Concern

  included do
    before_action :set_from_and_to_date
  end

  private def set_from_and_to_date
    if ranged_params?
      from_year = params[:from_year]
      from_month = params[:from_month]
      to_year = params[:to_year]
      to_month = params[:to_month]
    else
      from_year = params[:year]
      from_month = params[:month]
      to_year = params[:year]
      to_month = params[:month]
    end

    @from_date = Date.new(from_year.to_i, from_month.to_i).at_beginning_of_month
    @to_date = Date.new(to_year.to_i, to_month.to_i).at_end_of_month
  end

  private def ranged_params?
    params[:from_year].present? && params[:from_month].present? && params[:to_year].present? && params[:to_month].present?
  end
end
