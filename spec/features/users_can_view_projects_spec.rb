require "rails_helper"

RSpec.feature "Users can view a list of projects" do
  before do
    (100001..100006).each do |urn|
      mock_successful_api_responses(urn: urn, ukprn: 10061021)
    end

    allow(EstablishmentsFetcher).to receive(:new).and_return(mock_establishments_fetcher)
    allow(IncomingTrustsFetcher).to receive(:new).and_return(mock_trusts_fetcher)
  end

  let(:mock_establishments_fetcher) { double(EstablishmentsFetcher, call: true) }
  let(:mock_trusts_fetcher) { double(IncomingTrustsFetcher, call: true) }
  let(:team_leader) { create(:user, :team_leader, email: "teamleader@education.gov.uk") }
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer, email: "regionaldeliveryofficer@education.gov.uk") }
  let(:caseworker) { create(:user, :caseworker, email: "caseworker@education.gov.uk") }
  let(:user) { create(:user, email: "user@education.gov.uk") }
  let!(:unassigned_project) {
    create(
      :conversion_project,
      urn: 100001,
      conversion_date: Date.today.beginning_of_month + 3.years
    )
  }
  let!(:user_project) {
    create(
      :conversion_project,
      urn: 100002,
      caseworker: user,
      conversion_date: Date.today.beginning_of_month + 2.year
    )
  }
  let!(:completed_project) {
    create(
      :conversion_project,
      urn: 100004,
      caseworker: caseworker,
      regional_delivery_officer: regional_delivery_officer,
      conversion_date: Date.today.beginning_of_month + 6.months,
      completed_at: Date.today.beginning_of_month + 7.months
    )
  }
  let!(:caseworker_project) {
    create(
      :conversion_project,
      urn: 100003,
      caseworker: caseworker,
      regional_delivery_officer: regional_delivery_officer,
      conversion_date: Date.today.beginning_of_month + 1.years
    )
  }
  let!(:assigned_to_project_for_rdo) {
    create(
      :conversion_project,
      urn: 100005,
      caseworker: caseworker,
      regional_delivery_officer: nil,
      assigned_to: regional_delivery_officer,
      conversion_date: Date.today.beginning_of_month + 4.years
    )
  }
  let!(:assigned_to_project_for_caseworker) {
    create(
      :conversion_project,
      urn: 100006,
      caseworker: nil,
      regional_delivery_officer: nil,
      assigned_to: caseworker,
      conversion_date: Date.today.beginning_of_month + 5.years
    )
  }

  context "when the user is a team leader" do
    before do
      sign_in_with_user(team_leader)
    end

    scenario "can see all open projects on the project list regardless of assignment" do
      visit projects_path

      page_has_project(unassigned_project)
      page_has_project(user_project)
      page_has_project(caseworker_project)
    end

    scenario "the open projects are sorted by target completion date" do
      visit projects_path

      expect(page.find("ul.projects-list > li:nth-of-type(1)")).to have_content("100003")
      expect(page.find("ul.projects-list > li:nth-of-type(2)")).to have_content("100002")
      expect(page.find("ul.projects-list > li:nth-of-type(3)")).to have_content("100001")
    end

    scenario "projects are grouped under conversion date headings" do
      three_years_time = Date.today.beginning_of_month + 3.years

      visit projects_path

      expect(page).to have_css("h2", text: three_years_time.strftime("%B %Y openers"))
    end
  end

  context "when the user is a regional delivery officer" do
    before do
      sign_in_with_user(regional_delivery_officer)
    end

    scenario "can see projects on which they are the regional development officer" do
      visit projects_path

      expect(page).to_not have_content(unassigned_project.urn.to_s)
      expect(page).to_not have_content(user_project.urn.to_s)
      page_has_project(caseworker_project)
    end

    scenario "can see projects they are assigned to but are NOT the regional development officer" do
      visit projects_path

      page_has_project(assigned_to_project_for_rdo)
    end
  end

  context "when the user is a caseworker" do
    before do
      sign_in_with_user(caseworker)
    end

    scenario "can see projects on which they are the caseworker" do
      visit projects_path

      expect(page).to_not have_content(unassigned_project.urn.to_s)
      expect(page).to_not have_content(user_project.urn.to_s)
      page_has_project(caseworker_project)
    end

    scenario "can see projects they are assigned to but are NOT the caseworker for" do
      visit projects_path

      page_has_project(assigned_to_project_for_caseworker)
    end
  end

  context "when the user does not have an assigned role" do
    before(:each) do
      sign_in_with_user(user)
    end

    scenario "can only see assigned projects on the projects list" do
      visit projects_path

      expect(page).to_not have_content(unassigned_project.urn.to_s)
      expect(page).to have_content(user_project.urn.to_s)
      expect(page).to_not have_content(caseworker_project.urn.to_s)
    end
  end

  context "when there are no projects in a project list" do
    before do
      sign_in_with_user(user)
      Project.destroy_all
    end

    scenario "there is a message indicating there are no open projects" do
      visit projects_path

      expect(page).to have_content(I18n.t("project.index.empty"))
    end
  end

  private def page_has_project(project)
    urn = find("span", text: project.urn.to_s)

    within urn.ancestor("li") do
      expect(page).to have_content("School type: #{project.establishment.type}")
      expect(page).to have_content("Incoming trust: #{project.incoming_trust.name}")
      expect(page).to have_content("Local authority: #{project.establishment.local_authority}")
    end
  end
end

RSpec.feature "Users can view a single project" do
  let(:urn) { 123456 }
  let(:establishment) { build(:academies_api_establishment) }
  let(:mock_establishments_fetcher) { double(EstablishmentsFetcher, call: true) }
  let(:mock_trusts_fetcher) { double(IncomingTrustsFetcher, call: true) }

  before do
    mock_successful_api_establishment_response(urn: urn, establishment: establishment)
    mock_successful_api_responses(urn: urn, ukprn: 10061021)

    allow(EstablishmentsFetcher).to receive(:new).and_return(mock_establishments_fetcher)
    allow(IncomingTrustsFetcher).to receive(:new).and_return(mock_trusts_fetcher)
  end

  scenario "by following a link from the home page" do
    user = create(:user, :team_leader)
    sign_in_with_user(user)

    single_project = create(:conversion_project, urn: urn, assigned_to: user)

    visit root_path
    click_on establishment.name
    expect(page).to have_content(single_project.urn.to_s)
  end
end
