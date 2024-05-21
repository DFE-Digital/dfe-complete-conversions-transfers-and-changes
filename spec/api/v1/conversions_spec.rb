require "rails_helper"

RSpec.describe V1::Conversions do
  describe "get /" do
    it "returns an error" do
      get "/api/v1/projects/conversions"
      expect(response.body).to eq({error: "405 Not Allowed"}.to_json)
    end
  end

  describe "post /" do
    context "when there is a valid api key in the header" do
      before do
        ApiKey.create(api_key: "testkey", expires_at: Date.tomorrow)
        mock_successful_api_response_to_create_any_project
      end

      let(:regional_delivery_officer) { create(:regional_delivery_officer_user) }

      context "when all required params are present" do
        context "and the required params are valid" do
          it "creates a new project" do
            post "/api/v1/projects/conversions",
              params: {
                conversion_project: {
                  urn: 121813,
                  incoming_trust_ukprn: 10066123,
                  advisory_board_date: "2024-1-1",
                  advisory_board_conditions: "Some conditions",
                  provisional_conversion_date: "2025-1-1",
                  directive_academy_order: true,
                  created_by_email: regional_delivery_officer.email,
                  created_by_first_name: regional_delivery_officer.first_name,
                  created_by_last_name: regional_delivery_officer.last_name
                }
              },
              as: :json,
              headers: {Apikey: "testkey"}

            project = Project.last
            expect(response.body).to eq({conversion_project: "/projects/#{project.id}/information"}.to_json)
          end
        end

        context "but project creation fails" do
          before do
            allow_any_instance_of(Conversion::Project).to receive(:save).and_return(nil)
          end

          it "returns an error" do
            post "/api/v1/projects/conversions",
              params: {
                conversion_project: {
                  urn: 123456,
                  incoming_trust_ukprn: 10066123,
                  advisory_board_date: "2024-1-1",
                  advisory_board_conditions: "Some conditions",
                  provisional_conversion_date: "2025-1-1",
                  directive_academy_order: true,
                  created_by_email: regional_delivery_officer.email,
                  created_by_first_name: regional_delivery_officer.first_name,
                  created_by_last_name: regional_delivery_officer.last_name
                }
              },
              as: :json,
              headers: {Apikey: "testkey"}

            expect(response.body).to eq({error: "Project could not be created via API, urn: 123456"}.to_json)
          end
        end

        context "but the created_by email is not valid" do
          it "returns an error" do
            post "/api/v1/projects/conversions",
              params: {
                conversion_project: {
                  urn: 121813,
                  incoming_trust_ukprn: 10066123,
                  advisory_board_date: "2024-1-1",
                  advisory_board_conditions: "Some conditions",
                  provisional_conversion_date: "2025-1-1",
                  directive_academy_order: true,
                  created_by_email: "nobody@school.gov.uk",
                  created_by_first_name: "Jane",
                  created_by_last_name: "Unknown"
                }
              },
              as: :json,
              headers: {Apikey: "testkey"}

            expect(response.body).to eq({error: "Failed to save user during API project creation, urn: 121813"}.to_json)
          end
        end

        context "but the URN or UKPRN parameters are not valid" do
          it "creates a new project" do
            post "/api/v1/projects/conversions",
              params: {
                conversion_project: {
                  urn: 123,
                  incoming_trust_ukprn: 123,
                  advisory_board_date: "2024-1-1",
                  advisory_board_conditions: "Some conditions",
                  provisional_conversion_date: "2025-1-1",
                  directive_academy_order: true,
                  created_by_email: regional_delivery_officer.email,
                  created_by_first_name: regional_delivery_officer.first_name,
                  created_by_last_name: regional_delivery_officer.last_name
                }
              },
              as: :json,
              headers: {Apikey: "testkey"}

            expect(response.body).to eq({error: "Urn URN must be 6 digits long. For example, 123456. Incoming trust ukprn UKPRN must be 8 digits long and start with a 1. For example, 12345678."}.to_json)
          end
        end
      end

      context "when any required params are missing" do
        it "returns an error" do
          post "/api/v1/projects/conversions", headers: {Apikey: "testkey"}
          expect(response.body).to include("conversion_project is missing")
        end
      end
    end
  end

  describe "post form-a-mat/" do
    context "when there is a valid api key in the header" do
      before do
        ApiKey.create(api_key: "testkey", expires_at: Date.tomorrow)
        mock_successful_api_response_to_create_any_project
      end

      let(:regional_delivery_officer) { create(:regional_delivery_officer_user) }

      context "when all required params are present" do
        context "and the required params are valid" do
          it "creates a new Form a MAT project" do
            post "/api/v1/projects/conversions/form-a-mat",
              params: {
                conversion_project: {
                  urn: 121813,
                  new_trust_reference_number: "TR12345",
                  new_trust_name: "The New Trust",
                  advisory_board_date: "2024-1-1",
                  advisory_board_conditions: "Some conditions",
                  provisional_conversion_date: "2025-1-1",
                  directive_academy_order: true,
                  created_by_email: regional_delivery_officer.email,
                  created_by_first_name: regional_delivery_officer.first_name,
                  created_by_last_name: regional_delivery_officer.last_name
                }
              },
              as: :json,
              headers: {Apikey: "testkey"}

            project = Project.last
            expect(response.body).to eq({conversion_project: "/projects/#{project.id}/information"}.to_json)
          end
        end

        context "but the new Trust Reference Number is not valid" do
          it "returns an error" do
            post "/api/v1/projects/conversions/form-a-mat",
              params: {
                conversion_project: {
                  urn: 121813,
                  new_trust_reference_number: "12345",
                  new_trust_name: "The New Trust",
                  advisory_board_date: "2024-1-1",
                  advisory_board_conditions: "Some conditions",
                  provisional_conversion_date: "2025-1-1",
                  directive_academy_order: true,
                  created_by_email: regional_delivery_officer.email,
                  created_by_first_name: regional_delivery_officer.first_name,
                  created_by_last_name: regional_delivery_officer.last_name
                }
              },
              as: :json,
              headers: {Apikey: "testkey"}

            expect(response.body).to eq({error: "New trust reference number The Trust reference number must be 'TR' followed by 5 numbers, e.g. TR01234"}.to_json)
          end
        end
      end

      context "when any required params are missing" do
        it "returns an error" do
          post "/api/v1/projects/conversions/form-a-mat", headers: {Apikey: "testkey"}
          expect(response.body).to include("conversion_project is missing")
        end
      end

      context "when the 'regular' conversion parameters are posted to the Form a MAT endpoint" do
        it "returns an error" do
          post "/api/v1/projects/conversions/form-a-mat",
            params: {
              conversion_project: {
                urn: 121813,
                incoming_trust_ukprn: 10066123,
                advisory_board_date: "2024-1-1",
                advisory_board_conditions: "Some conditions",
                provisional_conversion_date: "2025-1-1",
                directive_academy_order: true,
                created_by_email: regional_delivery_officer.email,
                created_by_first_name: regional_delivery_officer.first_name,
                created_by_last_name: regional_delivery_officer.last_name
              }
            },
            as: :json,
            headers: {Apikey: "testkey"}

          expect(response.body).to eq({error: "conversion_project[new_trust_reference_number] is missing, conversion_project[new_trust_name] is missing"}.to_json)
        end
      end
    end
  end
end
