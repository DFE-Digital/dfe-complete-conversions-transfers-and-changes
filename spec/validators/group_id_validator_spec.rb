require "rails_helper"

RSpec.describe GroupIdValidator do
  subject { GroupIdValidatorTest.new }

  context "when the group id format is correct" do
    it "is valid" do
      subject.group_id = "GRP_12345678"

      expect(subject).to be_valid
    end
  end

  context "when the group id format is incorrect" do
    it "is invalid" do
      ["GRP12345678", "grp_12345678", "GRP_12345"].each do |incorrect_group_id|
        subject.group_id = incorrect_group_id

        expect(subject).to be_invalid
      end
    end
  end

  context "when the group exists" do
    context "and the incoming_trust_ukprn matches" do
      it "is valid" do
        create(:project_group, group_identifier: "GRP_12345678", trust_ukprn: 1234567)

        subject.group_id = "GRP_12345678"
        subject.incoming_trust_ukprn = 1234567

        expect(subject).to be_valid
      end
    end

    context "and the incoming_trust_ukprn does not match" do
      it "is invalid" do
        create(:project_group, group_identifier: "GRP_12345678", trust_ukprn: 1234567)

        subject.group_id = "GRP_12345678"
        subject.incoming_trust_ukprn = 7654321

        expect(subject).to be_invalid
      end
    end
  end
end

class GroupIdValidatorTest
  include ActiveModel::Validations
  attr_accessor :incoming_trust_ukprn
  attr_accessor :group_id

  validates_with GroupIdValidator
end
