class CookiesController < ApplicationController
  skip_before_action :redirect_unauthenticated_user

  def show

  end
end
