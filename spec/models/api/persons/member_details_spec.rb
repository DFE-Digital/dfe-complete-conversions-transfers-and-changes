require "rails_helper"

RSpec.describe Api::Persons::MemberDetails do
  let(:member) do
    described_class.new({
      firstName: "First",
      lastName: "Last",
      email: "lastf@parliament.gov.uk"
    }.with_indifferent_access)
  end

  describe "#name" do
    it "returns the full name of the member of parliament" do
      expect(member.name).to eql "First Last"
    end
  end

  describe "#email" do
    it "returns the email of the member of parliament" do
      expect(member.email).to eql "lastf@parliament.gov.uk"
    end
  end

  describe "#address" do
    it "returns the address of the house of commons" do
      expect(member.address).to eql ["House of Commons", "London", "SW1A 0AA"]
    end
  end
end
