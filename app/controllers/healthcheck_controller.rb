class HealthcheckController < ApplicationController
  skip_before_action :redirect_unauthenticated_user

  def check
    render json: {status: "OK"}, status: :ok
  end
end
