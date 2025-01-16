class PagesController < ApplicationController
  skip_before_action :redirect_unauthenticated_user

  def show
    return not_found_error unless StaticPages.names.include?(static_page_name)

    render static_page_name
  end

  private def static_page_name
    params[:id]
  end
end
