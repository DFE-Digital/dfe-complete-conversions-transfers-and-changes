module ApplicationInsightsEventTrackable
  extend ActiveSupport::Concern

  def track_event(message)
    if ENV.fetch("APPLICATION_INSIGHTS_KEY", nil)
      tc = ApplicationInsights::TelemetryClient.new(ENV.fetch("APPLICATION_INSIGHTS_KEY"))
      tc.track_event(message)
      tc.flush
    end
  end
end
