require "rails_helper"

RSpec.describe Api::Transfers::CreateProjectService, type: :model do
  def valid_transfer_parameters
    {
      urn: 123456,
      incoming_trust_ukprn: 10066123,
      outgoing_trust_ukprn: 10010324,
      advisory_board_date: "2024-1-1",
      advisory_board_conditions: "Some conditions",
      provisional_transfer_date: "2025-1-1",
      directive_academy_order: true,
      created_by_email: "test.user@education.gov.uk",
      created_by_first_name: "Test",
      created_by_last_name: "User",
      two_requires_improvement: true,
      prepare_id: 123456,
      inadequate_ofsted: true,
      financial_safeguarding_governance_issues: true,
      outgoing_trust_to_close: true,
      new_trust_reference_number: "TR12345",
      new_trust_name: "A new trust"
    }
  end

  before do
    mock_successful_api_response_to_create_any_project
  end

  subject { described_class.new(valid_transfer_parameters).call }

  it "creates a new project" do
    expect(subject).to be_a Transfer::Project
    expect(subject.persisted?).to be true

    expect(subject.urn).to eql 123456
    expect(subject.transfer_date).to eql Date.new(2025, 1, 1)
  end

  it "creates the tasks data for the project" do
    tasks_data = subject.tasks_data

    expect(tasks_data).to be_a Transfer::TasksData
    expect(tasks_data.persisted?).to be true

    expect(tasks_data.inadequate_ofsted).to be true
    expect(tasks_data.financial_safeguarding_governance_issues).to be true
    expect(tasks_data.outgoing_trust_to_close).to be true
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
      params = valid_transfer_parameters
      params[:created_by_email] = "invalid@example.com"

      expect { described_class.new(params).call }
        .to raise_error(Api::Transfers::CreateProjectService::ProjectCreationError)
    end
  end

  context "when the URN is not invalid" do
    it "raises an error" do
      params = valid_transfer_parameters
      params[:urn] = 123

      expect { described_class.new(params).call }
        .to raise_error(
          Api::Transfers::CreateProjectService::ProjectCreationError,
          "Urn URN must be 6 digits long. For example, 123456."
        )
    end
  end

  context "when the incoming trust UKPRN is invalid" do
    it "raises an error" do
      params = valid_transfer_parameters
      params[:incoming_trust_ukprn] = 87654321

      expect { described_class.new(params).call }
        .to raise_error(
          Api::Transfers::CreateProjectService::ProjectCreationError,
          "Incoming trust ukprn UKPRN must be 8 digits long and start with a 1. For example, 12345678."
        )
    end
  end

  context "when the Prepare ID is missing" do
    it "raises an error" do
      params = valid_transfer_parameters
      params[:prepare_id] = nil

      expect { described_class.new(params).call }
        .to raise_error(
          Api::Transfers::CreateProjectService::ProjectCreationError,
          "Prepare You must supply a Prepare ID when creating a project via the API"
        )
    end
  end

  context "when the Academies API returns an error on fetching the establishment" do
    before do
      mock_establishment_not_found(urn: 123456)
    end

    it "returns an error" do
      params = valid_transfer_parameters
      params[:urn] = 123456

      expect { described_class.new(params).call }
        .to raise_error(
          Api::Transfers::CreateProjectService::ProjectCreationError,
          "Failed to fetch establishment from Academies API during project creation, urn: 123456"
        )
    end
  end

  context "when the project save fails for an unknown reason" do
    before do
      allow_any_instance_of(Transfer::Project).to receive(:save).and_return(nil)
    end

    it "returns an error" do
      params = valid_transfer_parameters
      params[:urn] = 123456

      expect { described_class.new(params).call }
        .to raise_error(
          Api::Transfers::CreateProjectService::ProjectCreationError,
          "Transfer project could not be created via API, urn: 123456"
        )
    end
  end

  context "when creating a form a Multi Academy Trust (MAT) transfer" do
    it "saves the new trust details" do
      expect(subject.new_trust_reference_number).to eql "TR12345"
      expect(subject.new_trust_name).to eql "A new trust"
    end
  end
end
