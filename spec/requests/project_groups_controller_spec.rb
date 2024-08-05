require "rails_helper"

RSpec.describe ProjectGroupsController, type: :request do
  before do
    mock_all_academies_api_responses
    sign_in_with(user)
  end

  let(:user) { create(:user) }

  describe "#index" do
    context "when there are no groups" do
      it "shows a helpful message" do
        get project_groups_path

        expect(response.body).to include "No grouped projects have been added yet."
      end
    end
  end
end
