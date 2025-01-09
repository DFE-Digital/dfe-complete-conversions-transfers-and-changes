require "rails_helper"

RSpec.describe AcademiesApiPreFetcherService do
  before { Project.destroy_all }

  it "prefetches Academies API data in batches of 20 and populates projects" do
    api_client = mock_academies_api_client_get_establishments_and_trusts

    25.times do
      create(:conversion_project, incoming_trust_ukprn: 10010010)
    end

    projects = Project.all

    AcademiesApiPreFetcherService.new.call!(projects)

    expect(api_client).to have_received(:get_establishments).exactly(2).times
    expect(api_client).to have_received(:get_trusts).exactly(2).times

    expect(api_client).to have_received(:get_establishment).exactly(25).times
    expect(projects.last.establishment).not_to be_nil
    expect(projects.last.incoming_trust).not_to be_nil
  end

  it "handles eager loading" do
    mock_academies_api_client_get_establishments_and_trusts

    create(:conversion_project, urn: 123456, incoming_trust_ukprn: 10010010)

    projects = Project.all.includes(:tasks_data)

    expect(projects.last.establishment).not_to be_nil
    expect(projects.last.incoming_trust).not_to be_nil

    expect(projects.last.all_conditions_met?).to be false
  end

  it "raises an Academies API error if the establishments requests fail" do
    mock_academies_api_client_get_establishments_and_trusts_failure

    10.times do
      create(:conversion_project, incoming_trust_ukprn: 10010010)
    end

    projects = Project.all

    expect { AcademiesApiPreFetcherService.new.call!(projects) }.to raise_error(Api::AcademiesApi::Client::Error)
  end

  it "tracks the Academies API error if the trusts requests fail but does not raise" do
    ClimateControl.modify(APPLICATION_INSIGHTS_KEY: "fake-application-insights-key") do
      telemetry_client = double(ApplicationInsights::TelemetryClient, track_event: true, flush: true)
      allow(ApplicationInsights::TelemetryClient).to receive(:new).and_return(telemetry_client)

      establishment = double("Establishment", name: "Establishment Name", urn: "123456")
      api_client = mock_academies_api_client_get_establishments_and_trusts_failure
      allow(api_client).to receive(:get_establishments).and_return(Api::AcademiesApi::Client::Result.new([establishment], nil))

      10.times do
        create(:conversion_project, incoming_trust_ukprn: 10010010)
      end

      projects = Project.all
      AcademiesApiPreFetcherService.new.call!(projects)

      expect(telemetry_client).to have_received(:track_event)
    end
  end

  def mock_academies_api_client_get_establishments_and_trusts
    api_client = Api::AcademiesApi::Client.new

    establishment = double("Establishment", name: "Establishment Name", urn: "123456")
    trust = double("Trust", ukprn: "10010010")

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)

    allow(api_client).to receive(:get_establishments).and_return(Api::AcademiesApi::Client::Result.new([establishment], nil))
    allow(api_client).to receive(:get_trusts).and_return(Api::AcademiesApi::Client::Result.new([trust], nil))

    allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(trust, nil))
    allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(establishment, nil))

    api_client
  end

  def mock_academies_api_client_get_establishments_and_trusts_failure
    api_client = Api::AcademiesApi::Client.new

    establishment = double("Establishment", name: "Establishment Name", urn: "123456")
    trust = double("Trust", ukprn: "10010010")

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)

    allow(api_client).to receive(:get_establishments).and_return(Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::Error.new))
    allow(api_client).to receive(:get_trusts).and_return(Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::Error.new))

    allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(trust, nil))
    allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(establishment, nil))

    api_client
  end
end
