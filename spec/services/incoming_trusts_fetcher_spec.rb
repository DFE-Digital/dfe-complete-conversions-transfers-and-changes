require "rails_helper"

RSpec.describe IncomingTrustsFetcher do
  let(:incoming_trusts_fetcher) { described_class.new }

  describe "#call" do
    let(:projects) do
      [
        build(:conversion_project, incoming_trust_ukprn: 12345678),
        build(:conversion_project, incoming_trust_ukprn: 23456789)
      ]
    end
    let(:mock_client) { AcademiesApi::Client.new }
    let(:trust) { build(:academies_api_trust, ukprn: "12345678") }
    let(:trust_2) { build(:academies_api_trust, ukprn: "23456789") }
    let(:trusts_result) { AcademiesApi::Client::Result.new([trust, trust_2], nil) }

    before do
      allow(AcademiesApi::Client).to receive(:new).and_return(mock_client)
      allow(mock_client).to receive(:get_trust).and_return(true)

      allow(mock_client).to receive(:get_trusts).with([12345678, 23456789]).and_return(trusts_result)
    end

    subject! { incoming_trusts_fetcher.call(projects) }

    context "when projects is nil" do
      let(:projects) { nil }

      it { expect(subject).to be_nil }
    end

    context "when projects is an empty array" do
      let(:projects) { [] }

      it { expect(subject).to be_nil }
    end

    it "fetches Trust data and assigns it to the projects" do
      expect(projects.find { |project| project.incoming_trust_ukprn == 12345678 }.incoming_trust).to eq trust
      expect(projects.find { |project| project.incoming_trust_ukprn == 23456789 }.incoming_trust).to eq trust_2

      expect(mock_client).to_not have_received(:get_trust)
    end
  end
end
