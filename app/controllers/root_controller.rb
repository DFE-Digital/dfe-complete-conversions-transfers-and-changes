class RootController < ApplicationController
  def home
    return redirect_to unassigned_team_projects_path if current_user.team_leader?

    return redirect_to without_academy_urn_service_support_projects_path if current_user.service_support?

    return redirect_to in_progress_user_projects_path if current_user.caseworker? || current_user.regional_delivery_officer?

    redirect_to all_in_progress_projects_path
  end
end
