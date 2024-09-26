require "rails_helper"

RSpec.describe Api::Conversions::CreateProjectService do
  before do
    mock_successful_api_response_to_create_any_project
  end

  subject { described_class.new(valid_parameters).call }

  it "creates a new project" do
    expect(subject).to be_a Conversion::Project
    expect(subject.persisted?).to be true

    expect(subject.urn).to eql 123456
    expect(subject.conversion_date).to eql Date.new(2025, 1, 1)
  end

  it "creates the tasks data for the project" do
    tasks_data = subject.tasks_data

    expect(tasks_data).to be_a Conversion::TasksData
    expect(tasks_data.persisted?).to be true
  end

  it "creates the user to attribute the project to i.e the 'Regional Delivery Officer'" do
    user = subject.regional_delivery_officer

    expect(user.persisted?).to be true
    expect(user.email).to eql "test.user@education.gov.uk"
  end

  it "sets the project region to be the same as the establishment region" do
    expect(subject.region).to eql "west_midlands"
  end

  it "creates the user in the same regional team as the project establishment" do
    user = subject.regional_delivery_officer

    expect(user.team).to eql "west_midlands"
  end

  it "saves the Prepare ID on the project" do
    expect(subject.prepare_id).to eq(123456)
  end

  it "sets the initial state to be 'inactive'" do
    expect(subject.state).to eq("inactive")
  end

  context "when a user exists with the same email address" do
    it "assigns that user to the project and does not create another" do
      existing_user = create(
        :user,
        email: "test.user@education.gov.uk",
        first_name: "Test",
        last_name: "Last",
        team: :london
      )
      user = subject.regional_delivery_officer

      expect(user).to eql existing_user
      expect(User.count).to be 1
    end
  end

  context "when the user's email is not valid i.e. not @education.gov.uk" do
    it "raises an error" do
      params = valid_parameters
      params[:created_by_email] = "invalid@example.com"

      expect { described_class.new(params).call }
        .to raise_error(Api::Conversions::CreateProjectService::ValidationError)
    end
  end

  describe "a Form a MAT Conversion project" do
    it "saves the new trust details" do
      expect(subject.new_trust_reference_number).to eql "TR12345"
      expect(subject.new_trust_name).to eql "A new trust"
    end

    it "the project is a Form a MAT project" do
      params = valid_parameters
      params[:incoming_trust_ukprn] = nil
      result = described_class.new(params).call

      expect(result.form_a_mat?).to be true
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
    context "when the URN is invalid" do
      it "raises an error" do
        params = valid_parameters
        params[:urn] = 123

        expect { described_class.new(params).call }
          .to raise_error(
            Api::Conversions::CreateProjectService::ValidationError,
            "Urn URN must be 6 digits long. For example, 123456."
          )
      end
    end

    context "when the establishment for the URN cannot be found" do
      before { mock_academies_api_establishment_not_found(urn: 123456) }

      it "raises an error" do
        expect { described_class.new(valid_parameters).call }
          .to raise_error(
            Api::Conversions::CreateProjectService::ValidationError,
            "An establishment with URN: 123456 could not be found on the Academies API"
          )
      end
    end

    context "when the incoming trust UKPRN is invalid" do
      it "raises an error" do
        params = valid_parameters
        params[:incoming_trust_ukprn] = 87654321

        expect { described_class.new(params).call }
          .to raise_error(
            Api::Conversions::CreateProjectService::ValidationError,
            "Incoming trust ukprn UKPRN must be 8 digits long and start with a 1. For example, 12345678."
          )
      end
    end

    context "when the trust for the incoming trust UKPRN cannot be found" do
      before { mock_academies_api_trust_not_found(ukprn: 10066123) }

      it "raises an error" do
        expect { described_class.new(valid_parameters).call }
          .to raise_error(
            Api::Conversions::CreateProjectService::ValidationError,
            "A trust with UKPRN: 10066123 could not be found on the Academies API"
          )
      end
    end

    context "when the Prepare ID is missing" do
      it "raises an error" do
        params = valid_parameters
        params[:prepare_id] = nil

        expect { described_class.new(params).call }
          .to raise_error(
            Api::Conversions::CreateProjectService::ValidationError,
            "Prepare You must supply a Prepare ID when creating a project via the API"
          )
      end
    end

    context "when there is a in progress transfer project with the same URN" do
      it "raises an error" do
        create(:conversion_project, urn: 123456)

        expect { described_class.new(valid_parameters).call }
          .to raise_error(
            Api::Transfers::CreateProjectService::ValidationError,
            "Urn There is already an in-progress project with this URN"
          )
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

    context "when the advisory board date is in the future" do
      it "raises a validation error" do
        params = valid_parameters
        params[:advisory_board_date] = Date.today + 2.years

        expect { described_class.new(params).call }
          .to raise_error(Api::Conversions::CreateProjectService::ValidationError,
            "Advisory board date The advisory board date must be in the past")
      end
    end

    context "when the provisional conversion date is not on the 1st" do
      it "raises a validation error" do
        params = valid_parameters
        params[:provisional_conversion_date] = "2024-1-2"

        expect { described_class.new(params).call }
          .to raise_error(Api::Conversions::CreateProjectService::ValidationError,
            "Provisional conversion date must be on the first of the month")
      end
    end
  end

  describe "errors" do
    context "when the Academies API returns an error on fetching the establishment" do
      let(:user) { create(:regional_casework_services_user) }

      before do
        mock_academies_api_establishment_error(urn: 123456)
      end

      it "returns an error" do
        expect { described_class.new(valid_parameters).call }
          .to raise_error(Api::Conversions::CreateProjectService::CreationError,
            "Failed to fetch establishment with URN: 123456 on Academies API")
      end
    end

    context "when the Academies API returns an error on fetching the incoming trust" do
      before do
        mock_academies_api_trust_error(ukprn: 10066123)
      end

      it "raises an error" do
        expect { described_class.new(valid_parameters).call }
          .to raise_error(
            Api::Transfers::CreateProjectService::CreationError,
            "Failed to fetch trust with UKPRN: 10066123 on Academies API"
          )
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

    context "when the user cannot be saved" do
      before do
        allow(User).to receive(:find_or_create_by).and_raise(ActiveRecord::RecordInvalid)
      end

      it "raises an error" do
        params = valid_parameters
        params[:incoming_trust_ukprn] = nil

        expect { described_class.new(params).call }
          .to raise_error(Api::Conversions::CreateProjectService::CreationError,
            "Failed to save user during API project creation, urn: 123456")
      end
    end
  end

  def valid_parameters
    {
      urn: 123456,
      incoming_trust_ukprn: 10066123,
      new_trust_reference_number: "TR12345",
      new_trust_name: "A new trust",
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
end
