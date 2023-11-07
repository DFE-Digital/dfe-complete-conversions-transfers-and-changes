class SearchController < ApplicationController
  def results
    return unless query.present?

    search_service = ProjectSearchService.new
    @results = search_service.search(query)
    @query = query
    @count = @results.count
    @pager, @results = pagy_array(@results)
  end

  private def query
    params[:query]&.strip
  end
end
