class V1::Transfers < Grape::API
  before do
    authenticate!
  end

  resource :projects do
    params do
      requires :urn, type: Integer, documentation: {example: "123456"}
      requires :advisory_board_date, type: Date
      requires :advisory_board_conditions, type: String
      requires :provisional_transfer_date, type: Date, documentation: {example: (Date.today.at_beginning_of_month - 1.month).to_s}
      requires :created_by_email, type: String, documentation: {example: "first.last@education.gov.uk"}
      requires :created_by_first_name, type: String, documentation: {example: "First"}
      requires :created_by_last_name, type: String, documentation: {example: "Last"}
      requires :inadequate_ofsted, type: Boolean, default: false
      requires :financial_safeguarding_governance_issues, type: Boolean, default: false
      requires :outgoing_trust_ukprn, type: Integer
      requires :outgoing_trust_to_close, type: Boolean, default: false
      requires :prepare_id, type: Integer
      optional :group_id, type: String, documentation: {example: "GRP_12345678"}
    end

    resource :transfers do
      params do
        requires :incoming_trust_ukprn, type: Integer, documentation: {example: "12345678"}
      end

      desc "Create a transfer project" do
        failure [{code: 400, message: "Bad request"}]
        nickname "Transfer project"
        tags ["transfers"]
      end
      post "/" do
        project_params = declared(params)

        service = Api::Transfers::CreateProjectService.new(project_params)
        project = service.call

        {transfer_project_id: project.id}
      rescue Api::Transfers::CreateProjectService::ValidationError => e
        error!(e.message, 400)
      rescue Api::Transfers::CreateProjectService::CreationError => e
        error!(e.message)
      end

      resource "form-a-mat" do
        params do
          requires :new_trust_reference_number, type: String
          requires :new_trust_name, type: String
        end

        desc "Create a form a MAT transfer project" do
          failure [{code: 400, message: "Bad request"}]
          nickname "Form a multi academy trust transfer project"
          tags ["transfers"]
        end
        post "/" do
          project_params = declared(params)

          service = Api::Transfers::CreateProjectService.new(project_params)
          project = service.call

          {transfer_project_id: project.id}
        rescue Api::Transfers::CreateProjectService::ValidationError => e
          error!(e.message, 400)
        rescue Api::Transfers::CreateProjectService::CreationError => e
          error!(e.message)
        end
      end
    end
  end
end
