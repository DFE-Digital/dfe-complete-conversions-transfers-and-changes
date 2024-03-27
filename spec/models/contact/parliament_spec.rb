require "rails_helper"

RSpec.describe Contact::Parliament do
  let(:client) { Api::MembersApi::Client }
  let(:client_instance) { double }
  let(:name) { double(Api::MembersApi::MemberName, name_display_as: "Joe Bloggs") }
  let(:contact_details) { double(find: Api::MembersApi::MemberContactDetails.new.from_hash({email: "joe.bloggs@email.com", line1: "Houses of Parliment", postcode: "SW1A 0AA"})) }

  around do |spec|
    ClimateControl.modify(
      MEMBERS_API_HOST: "https://members-api.test"
    ) do
      spec.run
    end
  end

  before do
    allow(client).to receive(:new).and_return(client_instance)
    allow(client_instance).to receive(:member_id).and_return(Api::MembersApi::Client::Result.new(4744, nil))
    allow(client_instance).to receive(:member_name).and_return(Api::MembersApi::Client::Result.new(name, nil))
    allow(client_instance).to receive(:member_contact_details).and_return(Api::MembersApi::Client::Result.new(contact_details, nil))
  end

  describe "#initialize" do
    it "initializes a new instance with the member details" do
      member_of_parliament = described_class.new(constituency: "St Albans")

      expect(member_of_parliament.name).to eq("Joe Bloggs")
      expect(member_of_parliament.title).to eq("Member of Parliament for St Albans")
      expect(member_of_parliament.category).to eq("other")
      expect(member_of_parliament.id).to be_nil
      expect(member_of_parliament.organisation_name).to be_nil
    end
  end

  describe "#editable?" do
    it "is always false" do
      expect(described_class.new(constituency: "St Albans").editable?).to be false
    end
  end

  context "when the Member of Parliament is not found" do
    before do
      allow(client).to receive(:new).and_return(client_instance)
      allow(client_instance).to receive(:member_id).and_return(Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::NotFoundError.new))
    end

    it "raises a not found error" do
      expect { described_class.new(constituency: "Nowhereville") }.to raise_error(Api::MembersApi::Client::NotFoundError)
    end
  end

  context "when the Members API returns multiple results for the constituency" do
    before do
      allow(client).to receive(:new).and_return(client_instance)
      allow(client_instance).to receive(:member_id).and_return(Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::MultipleResultsError.new))
    end

    it "raises a a multiple results error" do
      expect { described_class.new(constituency: "Middlesbrough") }.to raise_error(Api::MembersApi::Client::MultipleResultsError)
    end
  end

  context "when the Members API returns an error response" do
    before do
      allow(client).to receive(:new).and_return(client_instance)
      allow(client_instance).to receive(:member_id).and_return(Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::Error.new))
    end

    it "raises a generic error" do
      expect { described_class.new(constituency: "Westminster") }.to raise_error(Api::MembersApi::Client::Error)
    end
  end
end
