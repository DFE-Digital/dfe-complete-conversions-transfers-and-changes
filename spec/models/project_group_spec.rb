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

      mock_academies_api_trust_success(ukprn: subject.trust_ukprn, trust: trust)

      expect(subject.trust).to be trust
    end

    it "returns an empty trust object with an error when the trust cannot be fetched" do
      subject = build(:project_group)

      mock_academies_api_trust_not_found(ukprn: subject.trust_ukprn)

      expect(subject.trust.original_name).to eql "Could not find trust for UKPRN 1234567"
    end

    it "only calls the API once" do
      subject = build(:project_group)
      trust = build(:academies_api_trust)

      api_client = mock_academies_api_trust_success(ukprn: subject.trust_ukprn, trust: trust)

      subject.trust
      subject.trust

      expect(api_client).to have_received(:get_trust).exactly(1).time
    end
  end
end
