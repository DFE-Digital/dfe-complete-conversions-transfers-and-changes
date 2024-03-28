require "rails_helper"

RSpec.describe Conversion::EditProjectForm, type: :model do
  let(:project) { build(:conversion_project, assigned_to: user) }
  let(:user) { build(:user, :caseworker) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
  end

  describe "#save" do
    context "when the form is valid" do
      it "updates an exsiting sharepoint link" do
        sharepoint_link_form = Conversion::EditProjectForm.new(project: project, args: { establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment-folder", incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder"})
        sharepoint_link_form.establishment_sharepoint_link = "https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link"
        sharepoint_link_form.incoming_trust_sharepoint_link = "https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link"
        sharepoint_link_form.save

        expect(project.establishment_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link")
        expect(project.incoming_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link")
      end
    end
  end
end
