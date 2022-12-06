require "rails_helper"

RSpec.describe EstablishmentsFetcher do
  let(:establishments_fetcher) { described_class.new }

  describe "#call" do
    let(:projects) do
      [
        build(:conversion_project, urn: 123456),
        build(:conversion_project, urn: 234567)
      ]
    end
    let(:mock_client) { AcademiesApi::Client.new }
    let(:establishment) { build(:academies_api_establishment, urn: "123456") }
    let(:establishment_2) { build(:academies_api_establishment, urn: "234567") }
    let(:establishment_result) { AcademiesApi::Client::Result.new([establishment, establishment_2], nil) }

    before do
      allow(AcademiesApi::Client).to receive(:new).and_return(mock_client)
      allow(mock_client).to receive(:get_establishment).and_return(true)
      allow(mock_client).to receive(:get_establishments).with([123456, 234567]).and_return(establishment_result)
    end

    subject! { establishments_fetcher.call(projects) }

    context "when projects is nil" do
      let(:projects) { nil }

      it { expect(subject).to be_nil }
    end

    context "when projects is an empty array" do
      let(:projects) { [] }

      it { expect(subject).to be_nil }
    end

    it "fetches Establishment data and assigns it to the projects" do
      expect(projects.find { |project| project.urn == 123456 }.establishment).to eq establishment
      expect(projects.find { |project| project.urn == 234567 }.establishment).to eq establishment_2

      expect(mock_client).to_not have_received(:get_establishment)
    end
  end
end
