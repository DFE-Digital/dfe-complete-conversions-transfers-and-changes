require "rails_helper"

RSpec.describe Conversion::EditProjectForm, type: :model do
  let(:project) { build(:conversion_project, assigned_to: user) }
  let(:user) { build(:user, :caseworker) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
  end

  describe "#save" do
    describe "Incoming trust UKPRN" do
      it "can be changed" do
        form = Conversion::EditProjectForm.new(project: project, args: {incoming_trust_ukprn: "12345678"})
        form.save

        expect(project.incoming_trust_ukprn).to eql 12345678
      end

      it "cannot be invalid" do
        form = Conversion::EditProjectForm.new(project: project, args: {incoming_trust_ukprn: "2461810"})

        expect(form.valid?).to be false
        expect(project.incoming_trust_ukprn).to eql 10061021
      end

      it "the trust must exist" do
        mock_trust_not_found(ukprn: 12345678)

        form = Conversion::EditProjectForm.new(project: project, args: {incoming_trust_ukprn: "12345678"})

        expect(form.valid?).to be false
        expect(project.incoming_trust_ukprn).to eql 10061021
      end
    end

    describe "Establishment SharePoint link" do
      it "can be changed" do
        form = Conversion::EditProjectForm.new(project: project, args: {establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link"})
        form.save

        expect(project.establishment_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link")
      end

      it "cannot be invalid" do
        form = Conversion::EditProjectForm.new(project: project, args: {establishment_sharepoint_link: "https://some-other-domain.com/establishment-folder-updated-link"})

        expect(form.valid?).to be false
      end

      it "cannot be empty" do
        form = Conversion::EditProjectForm.new(project: project, args: {establishment_sharepoint_link: ""})

        expect(form.valid?).to be false
      end
    end

    describe "Incoming trust SharePoint link" do
      it "can be changed" do
        form = Conversion::EditProjectForm.new(project: project, args: {incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link"})
        form.save

        expect(project.incoming_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link")
      end

      it "cannot be invalid" do
        form = Conversion::EditProjectForm.new(project: project, args: {incoming_trust_sharepoint_link: "https://some-other-domain.com/incoming-trust-folder-updated-link"})

        expect(form.valid?).to be false
      end

      it "cannot be empty" do
        form = Conversion::EditProjectForm.new(project: project, args: {incoming_trust_sharepoint_link: ""})

        expect(form.valid?).to be false
      end
    end
  end
end
