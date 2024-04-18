class FormAMultiAcademyTrust::ProjectGroupsController < ApplicationController
  after_action :verify_authorized
  rescue_from FormAMultiAcademyTrust::ProjectGroup::NoProjectsFoundError, with: :not_found_error

  def show
    @project_group = FormAMultiAcademyTrust::ProjectGroup.new(trn: params[:trn])
    authorize @project_group

    @pager, @projects = pagy(@project_group.projects)
    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end
