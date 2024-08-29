require "rails_helper"

RSpec.describe All::ByMonth::Conversions::ProjectsController, type: :request do
  let(:user) { create(:user, team: "data_consumers") }

  before do
    mock_all_academies_api_responses
    sign_in_with(user)
  end

  describe "#date_range_this_month" do
    it "redirects to the current month and year" do
      get date_range_this_month_all_by_month_conversions_projects_path
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(request.params.fetch(:from_month)).to eq Date.today.month.to_s
      expect(request.params.fetch(:from_year)).to eq Date.today.year.to_s
      expect(request.params.fetch(:to_month)).to eq Date.today.month.to_s
      expect(request.params.fetch(:to_year)).to eq Date.today.year.to_s
    end
  end

  describe "#date_range" do
    it "shows the date range in the page text" do
      get "/projects/all/by-month/conversions/from/1/2023/to/10/2023"
      expect(response.body).to include "January 2023 to October 2023"
    end

    it "shows details of any matching projects" do
      project = create(:conversion_project, significant_date_provisional: false, significant_date: Date.new(2023, 2, 1))
      create(:date_history, project: project, previous_date: Date.new(2023, 2, 1), revised_date: Date.new(2023, 3, 1))

      get "/projects/all/by-month/conversions/from/1/2023/to/3/2023"
      expect(response.body).to include(project.establishment.name)
      expect(response.body).to include(project.urn.to_s)
    end

    context "if the 'to' date is before the 'from' date" do
      it "redirect to the current month with an information message" do
        get "/projects/all/by-month/conversions/from/10/2023/to/3/2023"
        follow_redirect!
        follow_redirect! # This redirects twice

        expect(response.body).to include("The 'from' date cannot be after the 'to' date")
      end
    end
  end

  describe "#next_month" do
    it "redirects to the next upcoming month and year" do
      get next_month_all_by_month_conversions_projects_path
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(request.params.fetch(:month)).to eq (Date.today + 1.month).month.to_s
      expect(request.params.fetch(:year)).to eq (Date.today + 1.month).year.to_s
    end
  end

  describe "#single_month" do
    it "shows the date in the page text" do
      get "/projects/all/by-month/conversions/1/2023"
      expect(response.body).to include "January 2023"
    end

    it "shows details of any matching projects" do
      project = create(:conversion_project, significant_date_provisional: false, significant_date: Date.new(2023, 2, 1))

      get "/projects/all/by-month/conversions/2/2023"
      expect(response.body).to include(project.establishment.name)
      expect(response.body).to include(project.urn.to_s)
    end
  end
end
