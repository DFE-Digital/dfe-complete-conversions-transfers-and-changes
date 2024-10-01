class All::Handover::HandoversController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def check
    authorize Project, :handover?

    @project = Project.find(params[:id])

    case @project.type
    when "Conversion::Project"
      render "all/handover/projects/conversion/check"
    when "Transfer::Project"
      render "all/handover/projects/transfer/check"
    end
  end
end
