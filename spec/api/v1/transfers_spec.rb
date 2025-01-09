require "rails_helper"

RSpec.describe V1::Transfers do
  before {
    Project.destroy_all
    mock_successful_api_response_to_create_any_project
  }

  describe "authorisation" do
    context "when there is no api key in the header" do
      it "returns an error" do
        post "/api/v1/projects/transfers"
        expect(response.body).to eq({error: "Unauthorized. Invalid or expired token."}.to_json)
        expect(response.status).to eq(401)
      end
    end

    context "when there is an invalid api key in the header" do
      it "returns an Unauthorized error" do
        post "/api/v1/projects/transfers", headers: {ApiKey: "unknownkey"}
        expect(response.body).to eq({error: "Unauthorized. Invalid or expired token."}.to_json)
        expect(response.status).to eq(401)
      end
    end

    context "when there is an expired api key in the header" do
      before do
        ApiKey.create(api_key: "testkey", expires_at: Date.yesterday)
      end

      it "returns an Unauthorized error" do
        post "/api/v1/projects/transfers", headers: {ApiKey: "testkey"}
        expect(response.body).to eq({error: "Unauthorized. Invalid or expired token."}.to_json)
      end
    end
  end

  describe "get requests are not allowed" do
    context "when there is a valid api key" do
      before do
        ApiKey.create(api_key: "testkey", expires_at: Date.tomorrow)
      end

      it "returns Not Allowed for transfers" do
        get "/api/v1/projects/transfers", headers: {Apikey: "testkey"}
        expect(response.body).to eq({error: "405 Not Allowed"}.to_json)
        expect(response.status).to eq(405)
      end

      it "returns Not Allowed for form a MAT transfers" do
        get "/api/v1/projects/transfers/form-a-mat", headers: {Apikey: "testkey"}
        expect(response.body).to eq({error: "405 Not Allowed"}.to_json)
        expect(response.status).to eq(405)
      end
    end
  end

  describe "post to transfers" do
    before { ApiKey.create(api_key: "testkey", expires_at: Date.tomorrow) }

    context "when the request is successful" do
      it "returns the project id with the status code 201" do
        post "/api/v1/projects/transfers",
          params: valid_transfer_parameters,
          as: :json,
          headers: {Apikey: "testkey"}

        project = Project.last
        expect(response.body).to eq({transfer_project_id: project.id}.to_json)
        expect(response.status).to eq(201)
      end
    end

    context "when a required parameter is missing" do
      it "returns an error with the status code 400" do
        params = valid_transfer_parameters
        params.delete(:urn)

        post "/api/v1/projects/transfers",
          params: params,
          headers: {Apikey: "testkey"}

        expect(response.body).to include("urn is missing")
        expect(response.status).to eq(400)
      end
    end

    context "when an optional parameter is included" do
      it "is successful" do
        params = valid_form_a_mat_transfer_parameters
        params[:group_id] = "GRP_12345678"

        post "/api/v1/projects/transfers",
          params: params,
          as: :json,
          headers: {Apikey: "testkey"}

        project = Project.last
        expect(response.body).to eq({transfer_project_id: project.id}.to_json)
        expect(response.status).to eq(201)
      end
    end

    context "when there is a validation error" do
      it "returns the error with the status code 400" do
        params = valid_transfer_parameters
        params[:created_by_email] = "invalid@invalid.com"

        post "/api/v1/projects/transfers",
          params: params,
          as: :json,
          headers: {Apikey: "testkey"}

        expect(response.body).to include("validation_errors")
        expect(response.body).to include("created_by_email")
        expect(response.body).to include("invalid")
        expect(response.status).to eq(400)
      end

      it "rejects URNs and UKPRNs which are too short" do
        params = valid_transfer_parameters
        params[:incoming_trust_ukprn] = 0
        params[:urn] = 0

        post "/api/v1/projects/transfers",
          params: params,
          as: :json,
          headers: {Apikey: "testkey"}

        expect(response.body).to include("urn is invalid")
        expect(response.body).to include("incoming_trust_ukprn is invalid")
        expect(response.body).to include("invalid")
        expect(response.status).to eq(400)
      end
    end

    context "when there is an error" do
      before { allow_any_instance_of(Transfer::Project).to receive(:save).and_return(nil) }

      it "returns the error with the status code 500" do
        post "/api/v1/projects/transfers",
          params: valid_transfer_parameters,
          as: :json,
          headers: {Apikey: "testkey"}

        expect(response.body).to eq({error: "Transfer project could not be created via API, urn: 123456"}.to_json)
        expect(response.status).to eq(500)
      end
    end
  end

  describe "post transfers/form-a-mat/" do
    before { ApiKey.create(api_key: "testkey", expires_at: Date.tomorrow) }

    context "when the request is successful" do
      it "returns the project id with the status code 201" do
        post "/api/v1/projects/transfers/form-a-mat",
          params: valid_form_a_mat_transfer_parameters,
          as: :json,
          headers: {Apikey: "testkey"}

        project = Project.last
        expect(response.body).to eq({transfer_project_id: project.id}.to_json)
        expect(response.status).to eq(201)
      end
    end

    context "when a required parameter is missing" do
      it "returns an error with the status code 400" do
        params = valid_form_a_mat_transfer_parameters
        params.delete(:new_trust_reference_number)

        post "/api/v1/projects/transfers/form-a-mat",
          params: params,
          headers: {Apikey: "testkey"}

        expect(response.body).to include("new_trust_reference_number is missing")
        expect(response.status).to eq(400)
      end
    end

    context "when an optional parameter is included" do
      it "is successful" do
        params = valid_form_a_mat_transfer_parameters
        params[:group_id] = "GRP_12345678"

        post "/api/v1/projects/transfers/form-a-mat",
          params: params,
          as: :json,
          headers: {Apikey: "testkey"}

        project = Project.last
        expect(response.body).to eq({transfer_project_id: project.id}.to_json)
        expect(response.status).to eq(201)
      end
    end

    context "when there is a validation error" do
      it "returns the error with the status code 400" do
        params = valid_form_a_mat_transfer_parameters
        params[:created_by_email] = "invalid@invalid.com"

        post "/api/v1/projects/transfers/form-a-mat",
          params: params,
          as: :json,
          headers: {Apikey: "testkey"}

        expect(response.body).to include("validation_errors")
        expect(response.body).to include("created_by_email")
        expect(response.body).to include("invalid")
        expect(response.status).to eq(400)
      end
    end

    context "when there is an error" do
      before { allow_any_instance_of(Transfer::Project).to receive(:save).and_return(nil) }

      it "returns the error with the status code 500" do
        post "/api/v1/projects/transfers/form-a-mat",
          params: valid_form_a_mat_transfer_parameters,
          as: :json,
          headers: {Apikey: "testkey"}

        expect(response.body).to eq({error: "Transfer project could not be created via API, urn: 123456"}.to_json)
        expect(response.status).to eq(500)
      end
    end
  end

  def valid_transfer_parameters
    {
      urn: 123456,
      incoming_trust_ukprn: 12345678,
      advisory_board_date: "2024-1-1",
      advisory_board_conditions: "Some conditions",
      provisional_transfer_date: "2025-1-1",
      created_by_email: "test.user@education.gov.uk",
      created_by_first_name: "Test",
      created_by_last_name: "User",
      inadequate_ofsted: true,
      financial_safeguarding_governance_issues: true,
      outgoing_trust_ukprn: 12348765,
      outgoing_trust_to_close: true,
      prepare_id: 12345
    }
  end

  def valid_form_a_mat_transfer_parameters
    {
      urn: 123456,
      incoming_trust_ukprn: 12345678,
      advisory_board_date: "2024-1-1",
      advisory_board_conditions: "Some conditions",
      provisional_transfer_date: "2025-1-1",
      created_by_email: "test.user@education.gov.uk",
      created_by_first_name: "Test",
      created_by_last_name: "User",
      inadequate_ofsted: true,
      financial_safeguarding_governance_issues: true,
      outgoing_trust_ukprn: 12348765,
      outgoing_trust_to_close: true,
      prepare_id: 12345,
      new_trust_reference_number: "TR12345",
      new_trust_name: "A new trust"
    }
  end
end
