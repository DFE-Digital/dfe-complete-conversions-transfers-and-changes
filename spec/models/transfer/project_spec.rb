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
  end

  describe "#completable?" do
    before { mock_successful_api_response_to_create_any_project }

    it "returns true when all the mandatory conditions are completed" do
      project = create(:transfer_project)
      allow(project).to receive(:confirmed_date_and_in_the_past?).and_return(true)

      expect(project.completable?).to eq true
    end

    it "returns false if any of the mandatory conditions are not completed" do
      project = create(:transfer_project)
      allow(project).to receive(:confirmed_date_and_in_the_past?).and_return(false)

      expect(project.completable?).to eq false
    end
  end
end
