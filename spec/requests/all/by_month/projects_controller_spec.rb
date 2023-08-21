require "rails_helper"

RSpec.describe All::ByMonth::ProjectsController, type: :request do
  let(:team_leader) { create(:user, :team_leader) }

  before do
    mock_all_academies_api_responses
    sign_in_with(team_leader)
  end

  describe "#confirmed_next_month" do
    it "redirects to next month" do
      get confirmed_all_by_month_projects_path
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(request.params.fetch(:month)).to eq Date.today.next_month.month.to_s
      expect(request.params.fetch(:year)).to eq Date.today.next_month.year.to_s

      travel_to Date.today + 2.months do
        get confirmed_all_by_month_projects_path
        follow_redirect!

        expect(response).to have_http_status(:success)
        expect(request.params.fetch(:month)).to eq Date.today.next_month.month.to_s
        expect(request.params.fetch(:year)).to eq Date.today.next_month.year.to_s
      end
    end
  end

  describe "#confirmed" do
    context "when supplying a month and year" do
      context "when the year is missing" do
        it "returns a 404" do
          get "/projects/all/by-month/confirmed/1"
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when the month isn't in the scope 1..12" do
        it "returns a 404" do
          get "/projects/all/by-month/confirmed/13/2022"
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when the year isn't in the scope 2000-2499" do
        it "returns a 404" do
          get "/projects/all/by-month/confirmed/12/2555"
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when the month and year are present and in scope" do
        it "shows a page title with the month & year" do
          get "/projects/all/by-month/confirmed/1/2022"

          expect(response.body).to include("Academies opening in January 2022")
        end

        it "returns project details in table form" do
          conversion_project = create(:conversion_project, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false, urn: 100001)
          transfer_project = create(:transfer_project, transfer_date: Date.new(2022, 1, 1), transfer_date_provisional: false, urn: 100002)
          get "/projects/all/by-month/confirmed/1/2022"

          expect(response.body).to include(
            conversion_project.establishment.name,
            conversion_project.urn.to_s,
            transfer_project.establishment.name,
            transfer_project.urn.to_s
          )
        end

        it "only returns projects whose confirmed significant date is in that month & year" do
          conversion_project_in_scope = create(:conversion_project, urn: 100001, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false)
          transfer_project_in_scope = create(:conversion_project, urn: 100003, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false)
          project_not_in_scope = create(:conversion_project, urn: 100002, conversion_date: Date.new(2022, 2, 1), conversion_date_provisional: false)

          get "/projects/all/by-month/confirmed/1/2022"

          expect(response.body).to include(conversion_project_in_scope.urn.to_s)
          expect(response.body).to include(transfer_project_in_scope.urn.to_s)
          expect(response.body).to_not include(project_not_in_scope.urn.to_s)
        end

        context "when there are no academies opening in that month & year" do
          it "shows a helpful message" do
            get "/projects/all/by-month/confirmed/1/2022"

            expect(response.body).to include("There are currently no schools expected to become academies in January 2022")
          end
        end
      end
    end
  end

  describe "#revised_next_month" do
    it "redirects to next month" do
      get revised_all_by_month_projects_path
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(request.params.fetch(:month)).to eq Date.today.next_month.month.to_s
      expect(request.params.fetch(:year)).to eq Date.today.next_month.year.to_s

      travel_to Date.today + 2.months do
        get revised_all_by_month_projects_path
        follow_redirect!

        expect(response).to have_http_status(:success)
        expect(request.params.fetch(:month)).to eq Date.today.next_month.month.to_s
        expect(request.params.fetch(:year)).to eq Date.today.next_month.year.to_s
      end
    end
  end
end
