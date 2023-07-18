class RootController < ApplicationController
  def home
    return redirect_to unassigned_team_projects_path if current_user.manage_team?

    return redirect_to without_academy_urn_service_support_projects_path if current_user.service_support_team?

    return redirect_to in_progress_user_projects_path if current_user.assign_to_project? || current_user.add_new_project?

    redirect_to all_in_progress_projects_path
  end
end
