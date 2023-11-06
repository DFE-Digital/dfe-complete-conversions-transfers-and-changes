require "rails_helper"

RSpec.describe SearchController, type: :request do
  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with(create(:user))
  end

  describe "#results" do
    context "when no query parameter is passed" do
      it "shows an informational message" do
        get "/search"
        expect(response.body).to include(I18n.t("search.enter_search_term"))
      end
    end

    context "when no results are found" do
      it "shows an informational message" do
        get "/search?query=primary"
        expect(response.body).to include(I18n.t("search.no_results.html", search_term: "primary"))
      end
    end

    context "when one result is found" do
      let!(:project) { create(:conversion_project, urn: 123456) }
      let!(:establishment_1) { create(:gias_establishment, name: "Primary school", urn: 123456) }
      let!(:establishment_2) { create(:gias_establishment, name: "Secondary school", urn: 100001) }

      it "strips any whitespace from the search term" do
        get "/search?query= primary "
        expect(response.body).to include(I18n.t("search.result_count", count: 1))
      end

      it "shows the result count" do
        get "/search?query=primary"
        expect(response.body).to include(I18n.t("search.result_count", count: 1))
      end

      it "shows the matching school information" do
        get "/search?query=primary"
        expect(response.body).to include(project.urn.to_s)
      end
    end

    context "when more than one result is found" do
      let!(:project_1) { create(:conversion_project, urn: 123456) }
      let!(:project_2) { create(:conversion_project, urn: 999999) }
      let!(:project_3) { create(:conversion_project, urn: 100001) }
      let!(:establishment_1) { create(:gias_establishment, name: "Primary school", urn: 123456) }
      let!(:establishment_2) { create(:gias_establishment, name: "Secondary school", urn: 100001) }
      let!(:establishment_3) { create(:gias_establishment, name: "Another primary school", urn: 999999) }

      it "shows the result count" do
        get "/search?query=primary"
        expect(response.body).to include(I18n.t("search.result_count", count: 2))
      end

      it "shows the matching school information" do
        get "/search?query=primary"
        expect(response.body).to include(project_1.urn.to_s)
        expect(response.body).to include(project_2.urn.to_s)
      end
    end
  end
end
