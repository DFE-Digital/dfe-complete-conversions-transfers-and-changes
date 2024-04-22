require "rails_helper"

RSpec.describe All::InProgress::ProjectsController, type: :request do
  before do
    sign_in_with(create(:user))
  end

  describe "#all_index" do
    context "when there are no projects" do
      it "shows a helpful message" do
        get all_all_in_progress_projects_path

        expect(response.body).to include "There are no projects in progress"
      end
    end
  end

  describe "#conversions_index" do
    context "when there are no projects" do
      it "shows a helpful message" do
        get conversions_all_in_progress_projects_path

        expect(response.body).to include "There are no in-progress conversion projects"
      end
    end
  end

  describe "#transfers_index" do
    context "when there are no projects" do
      it "shows a helpful message" do
        get transfers_all_in_progress_projects_path

        expect(response.body).to include "There are no in-progress transfer projects"
      end
    end
  end

  describe "#form_a_multi_academy_trust_index" do
    context "when there are no projects to group into a form a mat" do
      it "shows a helpful message" do
        get form_a_multi_academy_trust_all_in_progress_projects_path

        expect(response.body).to include "There are no form a MAT projects"
      end
    end
  end
end
