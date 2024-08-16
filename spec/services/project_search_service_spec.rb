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

    context "when passed a string that looks like words, i.e. a school name" do
      it "returns the match by school name" do
        _matching_establishment = create(:gias_establishment, name: "St Albans Primary", urn: 100000)
        _non_matching_establishment = create(:gias_establishment, name: "Honeywell Primary", urn: 999999)

        matching_project = create(:transfer_project, urn: 100000)
        non_matching_project = create(:conversion_project, urn: 999999)

        service = described_class.new
        result = service.search("st albans")

        expect(result).to include(matching_project)
        expect(result).not_to include(non_matching_project)
      end
    end

    context "when passed an establishment number" do
      it "returns the match by establishment number" do
        _matching_establishment = create(:gias_establishment, urn: 100000, establishment_number: "1234")
        _non_matching_establishment = create(:gias_establishment, urn: 999999, establishment_number: "1000")

        matching_project = create(:transfer_project, urn: 100000)
        non_matching_project = create(:conversion_project, urn: 999999)

        service = described_class.new
        result = service.search("1234")

        expect(result).to include(matching_project)
        expect(result).not_to include(non_matching_project)
      end
    end

    context "when passed anything that does not match the recognized patterns" do
      context "a too-long number" do
        it "returns an empty result" do
          service = described_class.new
          result = service.search("999999999999")

          expect(result.count).to be_zero
        end
      end

      context "a too-short number" do
        it "returns an empty result" do
          service = described_class.new
          result = service.search("1")

          expect(result.count).to be_zero
        end
      end

      context "a mix of numbers and letters" do
        it "returns an empty result" do
          service = described_class.new
          result = service.search("111-this-is-not-a-school-999")

          expect(result.count).to be_zero
        end
      end
    end

    context "when the match is a deleted project" do
      it "does not include the match" do
        create(:conversion_project, :deleted, urn: 100000)

        service = described_class.new
        result = service.search("100000")

        expect(result.count).to be_zero
      end
    end
  end

  describe "#search_by_urns" do
    context "when one urn is passed" do
      context "when a match is found" do
        it "returns an array with the matches" do
          matching_project = create(:conversion_project, urn: 100000)
          another_matching_project = create(:transfer_project, urn: 100000)
          not_matching_project = create(:conversion_project, urn: 123456)

          service = described_class.new
          result = service.search_by_urns("100000")

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
          result = service.search_by_urns("123456")

          expect(result.count).to be_zero
        end
      end
    end

    context "when an array of urns is passed" do
      context "when matches are found" do
        it "returns an array with the matches" do
          matching_project = create(:conversion_project, urn: 100000)
          another_matching_project = create(:transfer_project, urn: 999999)
          not_matching_project = create(:conversion_project, urn: 123456)

          service = described_class.new
          result = service.search_by_urns(["100000", "999999"])

          expect(result.count).to eql 2

          expect(result).to include(matching_project)
          expect(result).to include(another_matching_project)

          expect(result).not_to include(not_matching_project)
        end
      end

      it "does not include deleted projects" do
        matching_project = create(:conversion_project, urn: 100000)
        deleted_matching_project = create(:transfer_project, :deleted, urn: 999999)

        service = described_class.new
        result = service.search_by_urns(["100000", "999999"])

        expect(result.count).to eql 1

        expect(result).to include(matching_project)

        expect(result).not_to include(deleted_matching_project)
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

    it "does not include deleted projects" do
      create(:conversion_project, :deleted, incoming_trust_ukprn: 12345678)

      service = described_class.new
      result = service.search_by_ukprn("12345678")

      expect(result.count).to be_zero
    end
  end

  describe "#search_by_words" do
    context "when matches are found" do
      it "returns an array with the matches" do
        _matching_establishment_1 = create(:gias_establishment, name: "St Albans Primary", urn: 100000)
        _matching_establishment_2 = create(:gias_establishment, name: "St Albans Secondary", urn: 100001)
        _non_matching_establishment = create(:gias_establishment, name: "Honeywell Primary", urn: 999999)

        matching_project_1 = create(:transfer_project, urn: 100000)
        matching_project_2 = create(:conversion_project, urn: 100001)
        non_matching_project = create(:conversion_project, urn: 999999)

        service = described_class.new
        result = service.search_by_words("st albans")

        expect(result).to include(matching_project_1)
        expect(result).to include(matching_project_2)
        expect(result).not_to include(non_matching_project)
      end
    end

    context "when no matches are found" do
      it "returns an empty result" do
        service = described_class.new
        result = service.search_by_words("st albans")

        expect(result.count).to be_zero
      end
    end

    it "does not include deleted projects" do
      create(:gias_establishment, urn: 123456, name: "Matching establishment")
      create(:conversion_project, :deleted, urn: "123456")

      service = described_class.new
      result = service.search_by_words("Matching establishment")

      expect(result.count).to be_zero
    end
  end

  describe "#search_by_establishment_number" do
    context "when matches are found" do
      it "returns an array with the matches" do
        _matching_establishment = create(:gias_establishment, urn: 100000, establishment_number: 1234)
        _non_matching_establishment = create(:gias_establishment, urn: 999999, establishment_number: 1000)

        matching_project = create(:transfer_project, urn: 100000)
        non_matching_project = create(:conversion_project, urn: 999999)

        service = described_class.new
        result = service.search_by_establishment_number("1234")

        expect(result).to include(matching_project)
        expect(result).not_to include(non_matching_project)
      end
    end

    context "when no matches are found" do
      it "returns an empty result" do
        service = described_class.new
        result = service.search_by_establishment_number("1234")

        expect(result.count).to be_zero
      end
    end

    it "does not include deleted projects" do
      create(:gias_establishment, urn: 123456, establishment_number: 1234)
      create(:conversion_project, :deleted, urn: "123456")

      service = described_class.new
      result = service.search_by_establishment_number("1234")

      expect(result.count).to be_zero
    end
  end
end
