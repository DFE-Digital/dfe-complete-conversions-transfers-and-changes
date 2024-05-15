class Api::Conversions::CreateProjectService
  class ProjectCreationError < StandardError; end

  def initialize(project_params)
    @project_params = project_params
  end

  def call
    user = find_or_create_user
    project = Conversion::Project.new(
      urn: @project_params[:urn],
      incoming_trust_ukprn: @project_params[:incoming_trust_ukprn],
      conversion_date: @project_params[:provisional_conversion_date],
      advisory_board_date: @project_params[:advisory_board_date],
      advisory_board_conditions: @project_params[:advisory_board_conditions],
      directive_academy_order: @project_params[:directive_academy_order],
      regional_delivery_officer_id: user.id
    )

    if project.save(validate: false)
      project
    else
      raise ProjectCreationError.new("Project could not be created via API, urn: #{@project_params[:urn]}")
    end
  end

  private def find_or_create_user
    user = User.find_or_create_by(email: @project_params[:created_by_email])
    unless user.persisted?
      user.update!(first_name: @project_params[:created_by_first_name], last_name: @project_params[:created_by_last_name], team: :regional_casework_services)
    end
    user
  rescue ActiveRecord::RecordInvalid
    raise ProjectCreationError.new("Failed to save user during API project creation, email: #{@project_params[:created_by_email]}")
  end
end
