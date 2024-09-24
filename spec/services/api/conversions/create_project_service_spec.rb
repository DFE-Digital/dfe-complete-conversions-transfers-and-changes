require "rails_helper"

RSpec.describe Api::Conversions::CreateProjectService do
  before do
    mock_successful_api_response_to_create_any_project
  end

  def valid_parameters
    {
      urn: 123456,
      incoming_trust_ukprn: 10066123,
      new_trust_reference_number: "TR12345",
      new_trust_name: "The New Trust",
      advisory_board_date: "2024-1-1",
      advisory_board_conditions: "Some conditions",
      provisional_conversion_date: "2025-1-1",
      directive_academy_order: true,
      created_by_email: "test.user@education.gov.uk",
      created_by_first_name: "Test",
      created_by_last_name: "User",
      prepare_id: 123456
    }
  end

  context "a 'regular' Conversion project" do
    context "when the params contain details for an existing user" do
      let(:user) { create(:regional_casework_services_user) }

      it "creates the project using the existing user" do
        result = described_class.new(valid_parameters).call

        expect(result).to be_a(Conversion::Project)
        expect(result.id).to eq(Conversion::Project.last.id)
      end

      it "creates a TasksData and assigns it to the project" do
        result = described_class.new(valid_parameters).call
        tasks_data = Conversion::TasksData.last

        expect(result).to be_a(Conversion::Project)
        expect(result.tasks_data).to eq(tasks_data)
      end

      it "sets the project region to be the same as the establishment region" do
        result = described_class.new(valid_parameters).call

        expect(result.region).to eq("west_midlands")
      end

      it "saves the Prepare ID on the project" do
        result = described_class.new(valid_parameters).call

        expect(result.prepare_id).to eq(123456)
      end

      it "sets the initial state to be 'inactive'" do
        result = described_class.new(valid_parameters).call

        expect(result.state).to eq("inactive")
      end
    end

    context "when the params contain details for an unknown user" do
      it "creates the project and a new user" do
        params = valid_parameters

        result = described_class.new(params).call
        new_user = User.find_by(email: "test.user@education.gov.uk")

        expect(result).to be_a(Conversion::Project)
        expect(result.id).to eq(Conversion::Project.last.id)
        expect(result.regional_delivery_officer_id).to eq(new_user.id)
      end

      it "puts the new user in the same regional team as the establishment" do
        project = described_class.new(valid_parameters).call
        new_user = User.find_by(email: "test.user@education.gov.uk")

        expect(new_user.team).to eq(project.region)
      end
    end

    context "when the user's email is not valid" do
      it "returns an error" do
        params = valid_parameters
        params[:created_by_email] = "test@school.uk"

        expect { described_class.new(params).call }
          .to raise_error(Api::Conversions::CreateProjectService::CreationError,
            "Failed to save user during API project creation, urn: 123456")
      end
    end

    context "when the URN or UKPRN are not valid" do
      it "returns validation errors" do
        params = valid_parameters
        params[:urn] = 100
        params[:incoming_trust_ukprn] = 123

        expect { described_class.new(params).call }
          .to raise_error(Api::Conversions::CreateProjectService::ValidationError,
            "Urn URN must be 6 digits long. For example, 123456. Incoming trust ukprn UKPRN must be 8 digits long and start with a 1. For example, 12345678.")
      end
    end

    context "when the Prepare ID is missing" do
      it "returns validation errors" do
        params = valid_parameters
        params[:prepare_id] = nil

        expect { described_class.new(params).call }
          .to raise_error(Api::Conversions::CreateProjectService::ValidationError,
            "Prepare You must supply a Prepare ID when creating a project via the API")
      end
    end

    context "when the Academies API returns an error on fetching the establishment" do
      let(:user) { create(:regional_casework_services_user) }

      before do
        mock_academies_api_establishment_not_found(urn: 123456)
      end

      it "returns an error" do
        expect { described_class.new(valid_parameters).call }
          .to raise_error(Api::Conversions::CreateProjectService::CreationError,
            "Failed to fetch establishment from Academies API during project creation, urn: 123456")
      end
    end

    context "when the project save fails for an unknown reason" do
      before do
        allow_any_instance_of(Conversion::Project).to receive(:save).and_return(nil)
      end

      let(:user) { create(:regional_casework_services_user) }

      it "returns an error" do
        expect { described_class.new(valid_parameters).call }
          .to raise_error(Api::Conversions::CreateProjectService::CreationError,
            "Conversion project could not be created via API, urn: 123456")
      end
    end
  end

  context "a Form a MAT Conversion project" do
    context "when the params contain details for an existing user" do
      let(:user) { create(:regional_casework_services_user) }

      it "creates the project using the existing user" do
        params = valid_parameters
        params[:incoming_trust_ukprn] = nil

        result = described_class.new(params).call

        expect(result).to be_a(Conversion::Project)
        expect(result.id).to eq(Conversion::Project.last.id)
      end

      it "the project is a Form a MAT project" do
        params = valid_parameters
        params[:incoming_trust_ukprn] = nil
        result = described_class.new(params).call

        expect(result.form_a_mat?).to be true
      end
    end

    context "when the new Trust Reference Number is not valid" do
      it "returns validation errors" do
        params = valid_parameters
        params[:incoming_trust_ukprn] = nil
        params[:new_trust_reference_number] = "12345"

        expect { described_class.new(params).call }
          .to raise_error(Api::Conversions::CreateProjectService::ValidationError,
            "New trust reference number The Trust reference number must be 'TR' followed by 5 numbers, e.g. TR01234")
      end
    end

    context "when the project cannot be saved" do
      before do
        allow_any_instance_of(Conversion::Project).to receive(:save).and_return(nil)
      end

      let(:user) { create(:regional_casework_services_user) }

      it "raises an error" do
        params = valid_parameters
        params[:incoming_trust_ukprn] = nil

        expect { described_class.new(params).call }
          .to raise_error(Api::Conversions::CreateProjectService::CreationError,
            "Conversion project could not be created via API, urn: 123456")
      end
    end
  end

  context "when the parameters are invalid" do
    it "does not attempt to find or create a user" do
      allow(User).to receive(:find_or_create_by).and_call_original
      params = valid_parameters
      params[:incoming_trust_ukprn] = nil
      params[:urn] = 1234

      expect { described_class.new(params).call }
        .to raise_error(Api::Conversions::CreateProjectService::ValidationError)
      expect(User).not_to have_received(:find_or_create_by)
    end
  end

  describe "groups" do
    context "when there is a group id" do
      context "when the group does not exist" do
        it "creates the group and adds the project" do
          params = valid_parameters
          params[:group_id] = "GRP_00000001"

          subject = described_class.new(params).call

          expect(subject.group).to be_present
          expect(subject.group.group_identifier).to eql "GRP_00000001"
          expect(ProjectGroup.count).to be 1
        end
      end

      context "but the id is not valid" do
        it "is invalid" do
          params = valid_parameters
          params[:group_id] = "G0001"

          subject = described_class.new(params)

          expect(subject).to be_invalid
        end
      end

      context "when the group already exists" do
        it "adds the project without creating a new group" do
          ProjectGroup.create(
            group_identifier: "GRP_00000002",
            trust_ukprn: 10066123
          )
          params = valid_parameters
          params[:group_id] = "GRP_00000002"

          subject = described_class.new(params).call

          expect(subject.group).to be_present
          expect(subject.group.group_identifier).to eql "GRP_00000002"
          expect(ProjectGroup.count).to be 1
        end

        context "but the incoming trust UKPRN does not match the others in the group" do
          it "is invalid" do
            ProjectGroup.create(
              group_identifier: "GRP_00000002",
              trust_ukprn: 10000000
            )
            params = valid_parameters
            params[:group_id] = "GRP_00000002"

            subject = described_class.new(params)

            expect(subject).to be_invalid
          end
        end
      end
    end
  end

  describe "validations" do
    context "when there is a in progress conversion project with the same URN" do
      it "raises an error" do
        create(:conversion_project, urn: 123456)

        expect { described_class.new(valid_parameters).call }
          .to raise_error(
            Api::Transfers::CreateProjectService::ValidationError,
            "Urn There is already an in-progress project with this URN"
          )
      end
    end
  end
end
