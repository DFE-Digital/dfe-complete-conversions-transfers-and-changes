require "rails_helper"

RSpec.describe ContactsHelper, type: :helper do
  describe "#has_contacts?" do
    context "when contacts is nil" do
      let(:contacts) { nil }

      it "returns false" do
        expect(helper.has_contacts?(contacts)).to be false
      end
    end

    context "when contacts is an empty array" do
      let(:contacts) { [] }

      it "returns false" do
        expect(helper.has_contacts?(contacts)).to be false
      end
    end

    context "when there are contacts" do
      let(:contacts) { [build(:project_contact)] }

      it "returns true" do
        expect(helper.has_contacts?(contacts)).to be true
      end
    end
  end

  describe "#category_header" do
    before { mock_successful_api_response_to_create_any_project }
    let(:project) { build(:transfer_project) }

    it "includes the establishment name when the category is 'school_or_academy'" do
      category = "school_or_academy"
      expect(helper.category_header(category, project)).to eq("#{project.establishment.name} contacts")
    end

    it "includes the incoming trust name when the category is 'incoming_trust'" do
      category = "incoming_trust"
      expect(helper.category_header(category, project)).to eq("#{project.incoming_trust.name} contacts")
    end

    it "includes the outgoing trust name when the category is 'outgoing_trust'" do
      category = "outgoing_trust"
      expect(helper.category_header(category, project)).to eq("#{project.outgoing_trust.name} contacts")
    end

    it "includes the local authority name when the category is 'local_authority'" do
      category = "local_authority"
      expect(helper.category_header(category, project)).to eq("#{project.local_authority.name} contacts")
    end

    it "includes the category name when the category is 'other'" do
      category = "other"
      expect(helper.category_header(category, project)).to eq("Other contacts")
    end

    it "includes the category name when the category is 'solicitor'" do
      category = "solicitor"
      expect(helper.category_header(category, project)).to eq("Solicitor contacts")
    end

    it "includes the category name when the category is 'diocese'" do
      category = "diocese"
      expect(helper.category_header(category, project)).to eq("Diocese contacts")
    end
  end

  describe "#has_primary_contact?" do
    it "returns true for the categories that have a primary contact" do
      expect(helper.has_primary_contact?("school_or_academy")).to be true
      expect(helper.has_primary_contact?("local_authority")).to be true
      expect(helper.has_primary_contact?("incoming_trust")).to be true
      expect(helper.has_primary_contact?("outgoing_trust")).to be true
    end

    it "returns false for other categories" do
      expect(helper.has_primary_contact?("other")).to be false
      expect(helper.has_primary_contact?("diocese")).to be false
      expect(helper.has_primary_contact?("solicitor")).to be false
    end
  end
end
