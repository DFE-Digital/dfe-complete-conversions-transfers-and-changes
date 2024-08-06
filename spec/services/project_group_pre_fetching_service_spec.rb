require "rails_helper"

RSpec.describe ProjectGroupPreFetchingService do
  it "pre fetches trusts for the passed groups and adds them to the groups" do
    fake_client = mock_academies_api_client_get_trusts
    first_trust = create(:project_group, trust_ukprn: 1234567)
    last_trust = create(:project_group, trust_ukprn: 7654321)
    all_groups = [first_trust, last_trust]

    described_class.new(all_groups).pre_fetch!

    all_groups.each do |group|
      group.trust
    end

    expect(fake_client).to have_received(:get_trusts).with([1234567, 7654321]).exactly(1).time
    expect(fake_client).not_to have_received(:get_trust)
  end

  it "does nothing and logs to MS Application Insights if the fetch fails" do
    fake_client = mock_academies_api_client_get_trusts_fails
    first_trust = create(:project_group, trust_ukprn: 1000000)
    last_trust = create(:project_group, trust_ukprn: 1100000)
    all_groups = [first_trust, last_trust]

    fake_application_insights_client = double(ApplicationInsights::TelemetryClient, track_event: true, flush: true)

    allow(ApplicationInsights::TelemetryClient).to receive(:new).and_return fake_application_insights_client

    service = described_class.new(all_groups)
    allow(service).to receive(:track_event).and_call_original

    ClimateControl.modify APPLICATION_INSIGHTS_KEY: "fake-key" do
      service.pre_fetch!

      all_groups.each do |group|
        group.trust
      end

      expect(fake_client).to have_received(:get_trust).exactly(2).times
      expect(ApplicationInsights::TelemetryClient).to have_received(:new).exactly(3).times
    end
  end

  def mock_academies_api_client_get_trusts
    first_trust = build(:academies_api_trust, ukprn: 1234567)
    last_trust = build(:academies_api_trust, ukprn: 7654321)

    fake_client = double(
      Api::AcademiesApi::Client,
      get_trusts: Api::AcademiesApi::Client::Result.new([first_trust, last_trust], nil),
      get_trust: Api::AcademiesApi::Client::Result.new(first_trust, nil)
    )

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(fake_client)

    fake_client
  end

  def mock_academies_api_client_get_trusts_fails
    fake_client = double(
      Api::AcademiesApi::Client,
      get_trusts: Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("Trust not found")),
      get_trust: Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("Trust not found"))
    )

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(fake_client)

    fake_client
  end
end
