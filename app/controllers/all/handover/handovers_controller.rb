class All::Handover::HandoversController < ApplicationController
  include Projectable
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  before_action :set_form, except: [:check, :new]
  after_action :verify_authorized

  def check
    authorize Project, :handover?

    case @project.type
    when "Conversion::Project"
      render "all/handover/projects/conversion/check"
    when "Transfer::Project"
      render "all/handover/projects/transfer/check"
    end
  end

  def new
    authorize Project, :handover?

    @form = NewHandoverForm.new(@project, @current_user)

    render new_template_path
  end

  def create
    authorize Project, :handover?

    return redirect_to_project if @project.incoming_trust_ukprn.blank?

    if @form.valid?
      case @form.assigned_to_regional_caseworker_team
      when true
        @form.save
        render "all/handover/projects/assigned_regional_casework_services"
      when false
        @form.save
        render "all/handover/projects/assigned_region"
      end
    else
      render new_template_path
    end
  end

  private def redirect_to_project
    flash[:error] = "This project is missing its incoming trust UKPRN so can not be handed over. " \
      "Service support must delete this project and add the UKPRN in Prepare. " \
      "The project can then be reimported to Complete."

    redirect_to project_path(@project)
  end

  private def new_template_path
    case @project.type
    when "Conversion::Project"
      "all/handover/projects/conversion/new"
    when "Transfer::Project"
      "all/handover/projects/transfer/new"
    end
  end

  private def set_form
    @form = NewHandoverForm.new(@project, @current_user, handover_params)
  end

  private def handover_params
    params.require(:new_handover_form).permit(
      :assigned_to_regional_caseworker_team,
      :handover_note_body,
      :establishment_sharepoint_link,
      :incoming_trust_sharepoint_link,
      :outgoing_trust_sharepoint_link,
      :two_requires_improvement
    )
  end
end
