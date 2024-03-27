require "rails_helper"

class TestClass
  include ApplicationInsightsEventTrackable
end

RSpec.describe ApplicationInsightsEventTrackable do
  it "makes the track_event instance method available" do
    expect(TestClass.new).to respond_to :track_event
  end

  it "tracks the event with Application Insights" do
    ClimateControl.modify(APPLICATION_INSIGHTS_KEY: "fake-application-insights-key") do
      telemetry_client = double(ApplicationInsights::TelemetryClient, track_event: true, flush: true)
      allow(ApplicationInsights::TelemetryClient).to receive(:new).and_return(telemetry_client)

      TestClass.new.track_event("test message")

      expect(telemetry_client).to have_received(:track_event).with("test message")
    end
  end

  it "does nothing when there is no Application Insights key" do
    allow(ApplicationInsights::TelemetryClient).to receive(:new)

    TestClass.new.track_event("test message")

    expect(ApplicationInsights::TelemetryClient).not_to have_received(:new)
  end
end
