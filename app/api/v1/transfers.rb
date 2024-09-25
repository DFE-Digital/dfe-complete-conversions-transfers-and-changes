class V1::Transfers < Grape::API
  before do
    authenticate!
  end

  resource :projects do
    params do
      requires :urn, type: Integer
      requires :advisory_board_date, type: Date
      requires :advisory_board_conditions, type: String
      requires :provisional_transfer_date, type: Date
      requires :created_by_email, type: String
      requires :created_by_first_name, type: String
      requires :created_by_last_name, type: String
      requires :inadequate_ofsted, type: Boolean
      requires :financial_safeguarding_governance_issues, type: Boolean
      requires :outgoing_trust_ukprn, type: Integer
      requires :outgoing_trust_to_close, type: Boolean
      requires :prepare_id, type: Integer
      optional :group_id, type: String
    end

    resource :transfers do
      params do
        requires :incoming_trust_ukprn, type: Integer
      end

      desc "Create a transfer project" do
        failure [{code: 400, message: "Bad request"}]
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
