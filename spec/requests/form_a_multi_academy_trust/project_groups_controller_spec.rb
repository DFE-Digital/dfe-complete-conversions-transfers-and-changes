require "rails_helper"

RSpec.describe FormAMultiAcademyTrust::ProjectGroupsController, type: :request do
  before do
    user = create(:user)
    sign_in_with(user)
  end

  describe "#show" do
    context "when a project with the trn can be found" do
      it "renders the show view" do
        mock_all_academies_api_responses
        project = create(:conversion_project, :form_a_mat)

        get form_a_multi_academy_trust_path(project.new_trust_reference_number)

        expect(response).to render_template("form_a_multi_academy_trust/project_groups/show")
      end
    end

    context "when a project with the trn cannot be found" do
      it "renders the not found view" do
        get form_a_multi_academy_trust_path("TR00000")

        expect(response).to render_template("pages/page_not_found")
      end
    end
  end
end
