class RootController < ApplicationController
  def home
    return redirect_to unassigned_regional_casework_services_projects_path if current_user.team_leader?

    return redirect_to new_all_projects_path if current_user.service_support?

    redirect_to in_progress_user_projects_path
  end
end
