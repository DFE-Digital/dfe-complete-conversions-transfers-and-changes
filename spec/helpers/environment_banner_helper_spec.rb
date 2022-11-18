require "rails_helper"

RSpec.describe EnvironmentBannerHelper, type: :helper do
  describe "#environment_banner" do
    subject { helper.environment_banner }

    context "when SENTRY_ENV is production" do
      before { allow(ENV).to receive(:fetch).with("SENTRY_ENV", "local_development").and_return("production") }

      it { expect(subject).to be_nil }
    end

    context "when SENTRY_ENV is development" do
      before { allow(ENV).to receive(:fetch).with("SENTRY_ENV", "local_development").and_return("development") }

      it { expect(subject).to eql(environment_tag("turquoise", "DEVELOPMENT ENVIRONMENT")) }
    end

    context "when SENTRY_ENV is local_development" do
      before { allow(ENV).to receive(:fetch).with("SENTRY_ENV", "local_development").and_return("local_development") }

      it { expect(subject).to eql(environment_tag("purple", "LOCAL DEVELOPMENT ENVIRONMENT")) }
    end

    context "when SENTRY_ENV is test" do
      before { allow(ENV).to receive(:fetch).with("SENTRY_ENV", "local_development").and_return("test") }

      it { expect(subject).to eql(environment_tag("orange", "TEST ENVIRONMENT")) }
    end
  end

  private def environment_tag(colour, environment_name)
    "<strong class=\"govuk-tag govuk-tag--#{colour} environment-banner\">#{environment_name}</strong>"
  end
end
