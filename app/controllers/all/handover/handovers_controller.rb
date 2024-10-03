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

    @form = NewHandoverSteppedForm.new(@project, @current_user)

    render new_template_path
  end

  def create
    authorize Project, :handover?

    if @form.valid?
      case @form.assigned_to_regional_caseworker_team
      when true
        @form.save
        render "all/handover/projects/assigned_regional_casework_services"
      when false
        render "all/handover/projects/assign"
      end
    else
      render new_template_path
    end
  end

  def assign
    authorize Project, :handover?

    if @form.valid?(:assign)
      @form.save
      render "all/handover/projects/assigned_region"
    else
      render "all/handover/projects/assign"
    end
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
    @form = NewHandoverSteppedForm.new(@project, @current_user, handover_params)
  end

  private def handover_params
    params.require(:new_handover_stepped_form).permit(
      :assigned_to_regional_caseworker_team,
      :handover_note_body,
      :establishment_sharepoint_link,
      :incoming_trust_sharepoint_link,
      :outgoing_trust_sharepoint_link,
      :two_requires_improvement,
      :email,
      :team
    )
  end
end
