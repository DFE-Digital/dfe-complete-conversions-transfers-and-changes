class V1::Conversions < Grape::API
  before do
    authenticate!
  end

  resource :projects do
    params do
      requires :urn, type: Integer
      requires :advisory_board_date, type: Date
      requires :advisory_board_conditions, type: String
      requires :provisional_conversion_date, type: Date
      requires :directive_academy_order, type: Boolean
      requires :created_by_email, type: String
      requires :created_by_first_name, type: String
      requires :created_by_last_name, type: String
      requires :prepare_id, type: Integer
    end

    resource :conversions do
      params do
        requires :incoming_trust_ukprn, type: Integer
      end

      desc "Create a conversion project"
      post "/" do
        project_params = declared(params)

        service = Api::Conversions::CreateProjectService.new(project_params)
        project = service.call

        {conversion_project_id: project.id}
      rescue Api::Conversions::CreateProjectService::ProjectCreationError => e
        error!(e.message)
      end

      resource "form-a-mat" do
        params do
          requires :new_trust_reference_number, type: String
          requires :new_trust_name, type: String
        end

        desc "Create a form a MAT conversion project"
        post "/" do
          project_params = declared(params)

          service = Api::Conversions::CreateProjectService.new(project_params)
          project = service.call

          {conversion_project_id: project.id}
        rescue Api::Conversions::CreateProjectService::ProjectCreationError => e
          error!(e.message)
        end
      end
    end
  end
end
