class RootController < ApplicationController
  def home
    return redirect_to unassigned_regional_casework_services_projects_path if current_user.team_leader?

    redirect_to in_progress_user_projects_path
  end
end
