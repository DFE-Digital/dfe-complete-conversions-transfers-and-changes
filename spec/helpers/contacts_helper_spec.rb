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
      allow(project).to receive(:local_authority).and_return(build(:local_authority))
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

  describe "#primary_contact_at_organisation" do
    before { mock_successful_api_response_to_create_any_project }

    it "returns nothing for contacts which are not Contact::Project type" do
      expect(helper.primary_contact_at_organisation(build(:director_of_child_services), "local_authority")).to be_nil
    end

    it "returns 'no' for categories that do not have a primary contact type" do
      expect(helper.primary_contact_at_organisation(build(:project_contact), "other")).to eq("No")
    end

    it "returns 'yes' when contact is the primary contact for that category" do
      project = build(:conversion_project)
      school_contact = create(:project_contact, project: project)
      trust_contact = create(:project_contact, project: project)
      local_authority_contact = create(:project_contact, project: project)
      project.establishment_main_contact = school_contact
      project.incoming_trust_main_contact = trust_contact
      project.local_authority_main_contact = local_authority_contact

      expect(helper.primary_contact_at_organisation(school_contact, "school_or_academy")).to eq("Yes")
      expect(helper.primary_contact_at_organisation(trust_contact, "incoming_trust")).to eq("Yes")
      expect(helper.primary_contact_at_organisation(local_authority_contact, "local_authority")).to eq("Yes")
    end

    it "returns 'no' when contact is not the primary contact for that category" do
      project = build(:conversion_project)
      school_contact = create(:project_contact, project: project)
      trust_contact = create(:project_contact, project: project)
      local_authority_contact = create(:project_contact, project: project)

      expect(helper.primary_contact_at_organisation(school_contact, "school_or_academy")).to eq("No")
      expect(helper.primary_contact_at_organisation(trust_contact, "incoming_trust")).to eq("No")
      expect(helper.primary_contact_at_organisation(local_authority_contact, "local_authority")).to eq("No")
    end
  end
end
