class StaticPagesController < ApplicationController
  skip_before_action :redirect_unauthenticated_user

  def privacy
  end
end
