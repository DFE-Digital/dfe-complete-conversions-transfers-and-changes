require "rails_helper"

RSpec.describe Api::MembersApi::MemberDetails do
  describe "#name" do
    it "returns the MP Name" do
      mp_name = double(name_display_as: "Member Parliment")
      mp_contact_details = double

      member_details = described_class.new(mp_name, mp_contact_details)

      expect(member_details.name).to eql "Member Parliment"
    end

    context "if the member name is nil" do
      it "returns nil" do
        mp_name = nil
        mp_contact_details = double

        member_details = described_class.new(mp_name, mp_contact_details)

        expect(member_details.name).to be_nil
      end
    end
  end

  describe "#email" do
    it "returns the MP email address" do
      mp_name = double
      mp_contact_details = double(email: "member.parliment@parliment.uk")

      member_details = described_class.new(mp_name, mp_contact_details)

      expect(member_details.email).to eql "member.parliment@parliment.uk"
    end

    context "if the member contact details is nil" do
      it "returns nil" do
        mp_name = double
        mp_contact_details = nil

        member_details = described_class.new(mp_name, mp_contact_details)

        expect(member_details.email).to be_nil
      end
    end
  end

  describe "#address" do
    context "when the address is across two lines" do
      it "returns the MP address which is always the Houses of Parliment" do
        mp_name = double
        mp_contact_details = double(
          line1: "Houses of Parliment",
          line2: "London",
          postcode: "SW1A 0AA"
        )

        member_details = described_class.new(mp_name, mp_contact_details)

        expect(member_details.address.line1).to eql "Houses of Parliment"
        expect(member_details.address.line2).to eql "London"
        expect(member_details.address.line3).to be_nil
        expect(member_details.address.postcode).to eql "SW1A 0AA"
      end
    end

    context "if the member contact details is nil" do
      it "returns an empty struct" do
        mp_name = double
        mp_contact_details = nil

        member_details = described_class.new(mp_name, mp_contact_details)

        expect(member_details.address.line1).to be_nil
        expect(member_details.address.line2).to be_nil
        expect(member_details.address.postcode).to be_nil
      end
    end
  end
end
