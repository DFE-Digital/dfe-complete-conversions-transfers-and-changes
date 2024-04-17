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
end
