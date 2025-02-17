class SearchController < ApplicationController
  def results
    return unless query.present?

    search_service = ProjectSearchService.new
    @results = search_service.search(query)
    @query = query
    @count = @results.count
    @pager, @results = pagy_array(@results)
  rescue ProjectSearchService::SearchError => error
    render "pages/search_error", locals: {error_message: error.message}
  end

  def user
    return render json: [] if query.nil? || query&.empty?

    @users = case user_query_type
    when "assignable"
      User.assignable.active
    else
      User.all.active
    end

    render json: @users.where(
      "CONCAT(LOWER(first_name), ' ', LOWER(last_name), ' (', LOWER(email), ')') LIKE ?", "%#{query.downcase}%"
    ).order(:last_name).limit(100).pluck(:first_name, :last_name, :email)
  end

  private def query
    params[:query]&.strip
  end

  private def user_query_type
    params[:type]&.strip
  end
end
