class HealthcheckController < ApplicationController
  skip_before_action :redirect_unauthenticated_user

  def check
    return render plain: "Healthy" if Ops::DbAvailability.db_available?

    render plain: "Unhealthy"
  end
end
