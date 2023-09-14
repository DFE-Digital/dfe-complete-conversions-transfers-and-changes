require "rails_helper"

RSpec.describe ProjectSearchService do
  before do
    mock_all_academies_api_responses
  end

  describe "#search" do
    context "when passed a URN i.e. a 6 digit number" do
      it "returns the match by URN" do
        matching_project = create(:conversion_project, urn: 100000)
        not_matching_project = create(:conversion_project, urn: 123456)

        service = described_class.new
        result = service.search("100000")

        expect(result.count).to eql 1
        expect(result).to include(matching_project)
        expect(result).not_to include(not_matching_project)
      end
    end

    context "when passed a UKPRN i.e. an 8 digit number" do
      it "returns the match by UKPRN" do
        matching_incoming_project = create(:conversion_project, incoming_trust_ukprn: 10000000)
        matching_outgoing_project = create(:transfer_project, outgoing_trust_ukprn: 10000000)

        not_matching_incoming_project = create(:conversion_project, incoming_trust_ukprn: 12345678)
        not_matching_outgoing_project = create(:transfer_project, outgoing_trust_ukprn: 12345678)

        service = described_class.new
        result = service.search("10000000")

        expect(result.count).to eql 2

        expect(result).to include(matching_incoming_project)
        expect(result).to include(matching_outgoing_project)

        expect(result).not_to include(not_matching_incoming_project)
        expect(result).not_to include(not_matching_outgoing_project)
      end
    end

    context "when passed a string" do
      it "returns an empty result" do
        service = described_class.new
        result = service.search("School name search not implemented")

        expect(result.count).to be_zero
      end
    end
  end

  describe "#search_by_urn" do
    context "when a match is found" do
      it "returns an array with the matches" do
        matching_project = create(:conversion_project, urn: 100000)
        another_matching_project = create(:transfer_project, urn: 100000)
        not_matching_project = create(:conversion_project, urn: 123456)

        service = described_class.new
        result = service.search_by_urn("100000")

        expect(result.count).to eql 2

        expect(result).to include(matching_project)
        expect(result).to include(another_matching_project)

        expect(result).not_to include(not_matching_project)
      end
    end

    context "when a match is not found" do
      it "returns an empty result" do
        create(:conversion_project, urn: 100000)
        create(:transfer_project, urn: 100000)

        service = described_class.new
        result = service.search_by_urn("123456")

        expect(result.count).to be_zero
      end
    end
  end

  describe "#search_by_ukprn" do
    context "when a match is found" do
      it "returns an array with the matches" do
        matching_incoming_project = create(:conversion_project, incoming_trust_ukprn: 10000000)
        matching_outgoing_project = create(:transfer_project, outgoing_trust_ukprn: 10000000)

        not_matching_incoming_project = create(:conversion_project, incoming_trust_ukprn: 12345678)
        not_matching_outgoing_project = create(:transfer_project, outgoing_trust_ukprn: 12345678)

        service = described_class.new
        result = service.search_by_ukprn("10000000")

        expect(result.count).to eql 2

        expect(result).to include(matching_incoming_project)
        expect(result).to include(matching_outgoing_project)

        expect(result).not_to include(not_matching_incoming_project)
        expect(result).not_to include(not_matching_outgoing_project)
      end
    end

    context "when a match is not found" do
      it "returns an empty result" do
        create(:conversion_project, incoming_trust_ukprn: 10000000)
        create(:transfer_project, outgoing_trust_ukprn: 10000000)

        service = described_class.new
        result = service.search_by_ukprn("12345678")

        expect(result.count).to be_zero
      end
    end
  end
end
