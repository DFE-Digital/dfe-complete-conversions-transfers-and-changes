require "rails_helper"

RSpec.describe Conversion::Details do
  describe "columns" do
    it { is_expected.to have_db_column(:type).of_type :string }
    it { is_expected.to have_db_column(:incoming_trust_ukprn).of_type :integer }
  end

  describe "relationships" do
    it { is_expected.to belong_to(:project) }
  end

  describe "#incoming_trust_ukprn" do
    context "when no trust with that UKPRN exists in the API" do
      let(:no_trust_found_result) do
        AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("No trust found with that UKPRN. Enter a valid UKPRN."))
      end

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
            receive(:get_trust) { no_trust_found_result }
      end

      it "is invalid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:incoming_trust_ukprn]).to include(I18n.t("errors.attributes.incoming_trust_ukprn.no_trust_found"))
      end
    end
  end
end
