require "rails_helper"

RSpec.describe Transfer::EditProjectForm, type: :model do
  let(:project) { build(:transfer_project, assigned_to: user) }
  let(:user) { build(:user, :caseworker) }

  subject { Transfer::EditProjectForm.new_from_project(project) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
  end

  describe "#update" do
    describe "Establishment SharePoint link" do
      it "can be changed" do
        updated_params = {establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link"}

        subject.update(updated_params)

        expect(project.establishment_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link")
      end

      it "cannot be invalid" do
        updated_params = {establishment_sharepoint_link: "https://some-other-domain.com/establishment-folder-updated-link"}

        expect(subject.update(updated_params)).to be false
        expect(project.establishment_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/establishment-folder")
      end

      it "cannot be empty" do
        updated_params = {establishment_sharepoint_link: ""}

        expect(subject.update(updated_params)).to be false
        expect(project.establishment_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/establishment-folder")
      end
    end

    describe "Incoming trust SharePoint link" do
      it "can be changed" do
        updated_params = {incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link"}

        subject.update(updated_params)

        expect(project.incoming_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link")
      end

      it "cannot be invalid" do
        updated_params = {incoming_trust_sharepoint_link: "https://some-other-domain.com/incoming-trust-folder-updated-link"}

        expect(subject.update(updated_params)).to be false
        expect(project.incoming_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/incoming-trust-folder")
      end

      it "cannot be empty" do
        updated_params = {incoming_trust_sharepoint_link: ""}

        expect(subject.update(updated_params)).to be false
        expect(project.incoming_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/incoming-trust-folder")
      end
    end

    describe "Outgoing trust SharePoint link" do
      it "can be changed" do
        updated_params = {outgoing_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/outing-trust-folder-updated-link"}

        subject.update(updated_params)

        expect(project.outgoing_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/outing-trust-folder-updated-link")
      end

      it "cannot be invalid" do
        updated_params = {outgoing_trust_sharepoint_link: "https://some-other-domain.com/outgoing-trust-folder-updated-link"}

        expect(subject.update(updated_params)).to be false
        expect(project.outgoing_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/outgoing-trust-folder")
      end

      it "cannot be empty" do
        updated_params = {outgoing_trust_sharepoint_link: ""}

        expect(subject.update(updated_params)).to be false
        expect(project.outgoing_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/outgoing-trust-folder")
      end
    end
  end
end
