class V1::Conversions < Grape::API
  resource :projects do
    resource :conversions do
      params do
        requires :conversion_project, type: Hash do
          requires :urn, type: Integer, regexp: /^[0-9]{6}$/
          requires :incoming_trust_ukprn, type: String, regexp: /^1[0-9]{7}$/
          requires :advisory_board_date, type: Date
          requires :advisory_board_conditions, type: String
          requires :provisional_conversion_date, type: Date
          requires :directive_academy_order, type: Boolean
          requires :created_by_email, type: String
          requires :created_by_first_name, type: String
          requires :created_by_last_name, type: String
        end
      end

      desc "Create a conversion project"
      post "/" do
        authenticate!

        project_params = declared(params)[:conversion_project]

        service = Api::Conversions::CreateProjectService.new(project_params)
        project = service.call

        {conversion_project: Rails.application.routes.url_helpers.project_information_path(project)}
      rescue Api::Conversions::CreateProjectService::ProjectCreationError => e
        {error: e.message}
      end
    end
  end
end
