require "rails_helper"

RSpec.describe Transfer::Project do
  describe ".policy_class" do
    it "returns the correct policy" do
      expect(described_class.policy_class).to eql(ProjectPolicy)
    end
  end

  describe "#outgoing_trust_ukprn" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:outgoing_trust_ukprn) }

    context "when the outgoing_trust_ukprn is not a number" do
      subject { described_class.new(outgoing_trust_ukprn: "Super Schools Trust") }

      it "is invalid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:outgoing_trust_ukprn]).to include(I18n.t("errors.attributes.outgoing_trust_ukprn.must_be_correct_format"))
      end
    end

    context "when no trust with that UKPRN exists in the API and the UKPRN is present" do
      let(:no_trust_found_result) do
        Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("No trust found with that UKPRN. Enter a valid UKPRN."))
      end

      subject { described_class.new(outgoing_trust_ukprn: 12345678) }

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_trust) { no_trust_found_result }
      end

      it "is invalid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:outgoing_trust_ukprn]).to include(I18n.t("errors.attributes.outgoing_trust_ukprn.no_trust_found"))
      end
    end
  end

  describe "#all_conditions_met" do
    it "returns false" do
      expect(described_class.new.all_conditions_met?).to be false
    end
  end
end
