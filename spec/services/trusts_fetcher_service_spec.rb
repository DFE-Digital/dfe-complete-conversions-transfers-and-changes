require "rails_helper"

RSpec.describe TrustsFetcherService do
  describe "#paged!" do
    it "fetches the trusts and updates the projects" do
      mock_academies_api_client_get_trusts_success

      create(:conversion_project, incoming_trust: nil)
      projects = Project.all
      described_class.new(projects).paged!

      expect(projects.first.incoming_trust).not_to be_nil
    end

    it "raises when more records are passed in that is acceptable to prefetch without batching" do
      projects = build_list(:conversion_project, 21)

      expect { described_class.new(projects).paged! }.to raise_error(ArgumentError)
    end

    it "returns nil if passed nil" do
      expect(described_class.new(nil).paged!).to be_nil
    end

    it "returns nil if there are no projects" do
      expect(described_class.new([]).paged!).to be_nil
    end

    it "raises when the Academies API has an error and logs to Application Insights" do
      ClimateControl.modify(APPLICATION_INSIGHTS_KEY: "not-a-real-key") do
        mock_academies_api_client_get_trusts_error
        mock_application_insight_client

        create(:conversion_project)

        expect { described_class.new(Project.all).paged! }.to raise_error(Api::AcademiesApi::Client::Error)
        expect(ApplicationInsights::TelemetryClient).to have_received(:new).exactly(1).time
      end
    end
  end

  describe "#batched!" do
    it "fetches the trusts and updates the projects" do
      mock_academies_api_client_get_trusts_success
      create(:conversion_project, incoming_trust: nil)
      projects = Project.all

      described_class.new(projects).batched!

      expect(projects.first.incoming_trust).not_to be_nil
    end

    context "when there is a single batch of 10 projects or less" do
      it "calls the API once" do
        api_client = mock_academies_api_client_get_trusts_success
        create_list(:conversion_project, 6)
        projects = Project.all

        described_class.new(projects).batched!

        expect(api_client).to have_received(:get_trusts).exactly(1).times
      end
    end

    context "when there are multiple batches of projects" do
      it "calls the API the appropriate number of times" do
        api_client = mock_academies_api_client_get_trusts_success
        create_list(:conversion_project, 21)
        projects = Project.all

        described_class.new(projects).batched!

        expect(api_client).to have_received(:get_trusts).exactly(3).times
      end
    end

    it "raises unless an ActiveRecord relation is passed in" do
      project = build(:conversion_project)

      expect { described_class.new([project]).batched! }.to raise_error(ArgumentError)
    end

    it "returns nil if passed nil" do
      expect(described_class.new(nil).batched!).to be_nil
    end

    it "returns nil if there are no projects" do
      expect(described_class.new([]).batched!).to be_nil
    end

    it "raises when the Academies API has an error" do
      ClimateControl.modify(APPLICATION_INSIGHTS_KEY: "not-a-real-key") do
        mock_academies_api_client_get_trusts_error
        mock_application_insight_client

        create(:conversion_project)

        expect { described_class.new(Project.all).batched! }.to raise_error(Api::AcademiesApi::Client::Error)
        expect(ApplicationInsights::TelemetryClient).to have_received(:new).exactly(1).time
      end
    end
  end

  def mock_application_insight_client
    application_insight_client = double(track_event: true, flush: true)
    allow(ApplicationInsights::TelemetryClient).to receive(:new).and_return(application_insight_client)
    application_insight_client
  end

  def mock_academies_api_client_get_trusts_success
    api_client = Api::AcademiesApi::Client.new
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)
    allow(api_client).to receive(:get_trusts).and_return(Api::AcademiesApi::Client::Result.new([double("Trust", ukprn: true)], nil))

    allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(double("Trust"), nil))
    allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(double("Establishment"), nil))
    api_client
  end

  def mock_academies_api_client_get_trusts_error
    api_client = Api::AcademiesApi::Client.new
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)
    allow(api_client).to receive(:get_trusts).and_return(Api::AcademiesApi::Client::Result.new(nil, double("Academies API Error")))

    allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(double("Trust"), nil))
    allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(double("Establishment"), nil))
    api_client
  end
end
