require "rails_helper"

RSpec.describe ProjectGroup, type: :model do
  describe "columns" do
    it { is_expected.to have_db_column(:trust_ukprn).of_type :integer }
    it { is_expected.to have_db_column(:group_identifier).of_type :string }
  end

  describe "associations" do
    it { is_expected.to have_many(:projects) }
  end

  describe "#trust" do
    it "fetches the trust for the group from the api" do
      subject = build(:project_group)
      trust = build(:academies_api_trust)

      mock_successful_api_trust_response(ukprn: subject.trust_ukprn, trust: trust)

      expect(subject.trust).to be trust
    end

    it "returns an empty trust object with an error when the trust cannot be fetched" do
      subject = build(:project_group)

      mock_trust_not_found(ukprn: subject.trust_ukprn)

      expect(subject.trust.original_name).to eql "Could not find trust for UKPRN 1234567"
    end
  end
end
