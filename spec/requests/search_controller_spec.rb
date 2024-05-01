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

  describe "#user" do
    let!(:active_user) { create(:user, team: :regional_casework_services, active: true, first_name: "First", last_name: "Last", email: "first.last@education.gov.uk") }
    let!(:inactive_user) { create(:user, team: :regional_casework_services, active: false, email: "inactive.user@education.gov.uk") }
    let!(:assignable_user) { create(:user, team: :regional_casework_services, active: true, assign_to_project: true, email: "assignable.user@education.gov.uk") }
    let!(:unassignable_user) { create(:user, team: :service_support, active: true, assign_to_project: false, email: "unassignable.user@education.gov.uk") }

    it "can search by first name" do
      get "/search/user?query=first"

      result = JSON.parse(response.body)

      expect(result.count).to be 1
      expect(result.first).to include active_user.email
    end

    it "can search by last name" do
      get "/search/user?query=last"

      result = JSON.parse(response.body)

      expect(result.count).to be 1
      expect(result.first).to include active_user.email
    end

    it "can search by email address" do
      get "/search/user?query=first.last@education.gov.uk"

      result = JSON.parse(response.body)

      expect(result.count).to be 1
      expect(result.first).to include active_user.email
    end

    it "returns all active users by default" do
      get "/search/user?query=education.gov.uk"

      expect(response.body).to include active_user.email
      expect(response.body).to include assignable_user.email
      expect(response.body).to include unassignable_user.email
    end

    it "returns only active users" do
      get "/search/user?query=education.gov.uk"

      expect(response.body).not_to include inactive_user.email
    end

    context "with the type set to assignable" do
      it "returns only assignable users" do
        get "/search/user?type=assignable&query=education.gov.uk"

        expect(response.body).to include assignable_user.email
        expect(response.body).not_to include unassignable_user.email
      end
    end

    context "when there is no match" do
      it "returns an empty set and success" do
        get "/search/user?query=not-a-match"

        result = JSON.parse(response.body)

        expect(response.status).to be 200
        expect(result).to eql([])
      end
    end

    context "when the query is empty" do
      it "returns an emmpty set and success" do
        get "/search/user?query="

        result = JSON.parse(response.body)

        expect(response.status).to be 200
        expect(result).to eql([])
      end
    end

    context "when the query is not present" do
      it "returns an emmpty set and success" do
        get "/search/user"

        result = JSON.parse(response.body)

        expect(response.status).to be 200
        expect(result).to eql([])
      end
    end
  end
end
