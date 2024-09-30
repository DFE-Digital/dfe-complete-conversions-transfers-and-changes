class V1::Conversions < Grape::API
  before do
    authenticate!
  end

  resource :projects do
    params do
      requires :urn, type: Integer, documentation: {example: "123456"}
      requires :advisory_board_date, type: Date
      requires :advisory_board_conditions, type: String
      requires :provisional_conversion_date, type: Date, documentation: {example: (Date.today.at_beginning_of_month - 1.month).to_s}
      requires :directive_academy_order, type: Boolean, default: false
      requires :created_by_email, type: String, documentation: {example: "first.last@education.gov.uk"}
      requires :created_by_first_name, type: String, documentation: {example: "First"}
      requires :created_by_last_name, type: String, documentation: {example: "Last"}
      requires :prepare_id, type: Integer
      optional :group_id, type: String, documentation: {example: "GRP_12345678"}
    end

    resource :conversions do
      params do
        requires :incoming_trust_ukprn, type: Integer, documentation: {example: "12345678"}
      end

      desc "Create a conversion project" do
        failure [{code: 400, message: "Bad request"}]
        nickname "Conversion project"
        tags ["conversions"]
      end
      post "/" do
        project_params = declared(params)

        service = Api::Conversions::CreateProjectService.new(project_params)
        project = service.call

        {conversion_project_id: project.id}
      rescue Api::Conversions::CreateProjectService::ValidationError => e
        error!(e.message, 400)
      rescue Api::Conversions::CreateProjectService::CreationError => e
        error!(e.message)
      end

      resource "form-a-mat" do
        params do
          requires :new_trust_reference_number, type: String, documentation: {example: "TR12345"}
          requires :new_trust_name, type: String
        end

        desc "Create a form a MAT conversion project" do
          failure [{code: 400, message: "Bad request"}]
          nickname "Form a multi academy trust conversion project"
          tags ["conversions"]
        end
        post "/" do
          project_params = declared(params)

          service = Api::Conversions::CreateProjectService.new(project_params)
          project = service.call

          {conversion_project_id: project.id}
        rescue Api::Conversions::CreateProjectService::ValidationError => e
          error!(e.message, 400)
        rescue Api::Conversions::CreateProjectService::CreationError => e
          error!(e.message)
        end
      end
    end
  end
end
