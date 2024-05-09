require "rails_helper"

RSpec.describe InternalContacts::ProjectsController, type: :request do
  let(:user) { create(:user, :team_leader) }

  before do
    sign_in_with(user)
    mock_all_academies_api_responses
  end

  describe "editing the assigned to user" do
    it "redirects back from the internals contact tab" do
      assignee = create(:user, :caseworker)
      project = create(:conversion_project)
      mock_session_with_return_url(project_internal_contacts_path(project))

      put project_internal_contacts_assigned_user_path(project),
        params: {internal_contacts_edit_assigned_user_form: {email: assignee.email}}

      expect(response).to redirect_to(project_internal_contacts_path(project))
    end

    it "redirects back from the unassigned projects view" do
      assignee = create(:user, :caseworker)
      project = create(:conversion_project)
      mock_session_with_return_url(unassigned_team_projects_url)

      put project_internal_contacts_assigned_user_path(project),
        params: {internal_contacts_edit_assigned_user_form: {email: assignee.email}}

      expect(response).to redirect_to(unassigned_team_projects_url)
    end

    it "does not redirect to paths not on the application host, defaulting back to internal contacts instead" do
      assignee = create(:user, :caseworker)
      project = create(:conversion_project)
      mock_session_with_return_url("https://evil.com/hack")

      put project_internal_contacts_assigned_user_path(project),
        params: {internal_contacts_edit_assigned_user_form: {email: assignee.email}}

      expect(response).to redirect_to(project_internal_contacts_path(project))
    end

    it "shows the edit form when invalid" do
      project = create(:conversion_project)

      put project_internal_contacts_assigned_user_path(project),
        params: {internal_contacts_edit_assigned_user_form: {email: "not.valid@other-domain.com"}}

      expect(response).to render_template(:edit_assigned_user)
    end
  end

  describe "editing the added by user" do
    it "shows the edit form when invalid" do
      project = create(:conversion_project)

      put project_internal_contacts_added_by_user_path(project),
        params: {internal_contacts_edit_added_by_user_form: {email: "not.valid@other-domain.com"}}

      expect(response).to render_template(:edit_added_by_user)
    end
  end

  describe "editing the team" do
    it "handles both conversions and transfers" do
      transfer_project = create(:transfer_project)

      put project_internal_contacts_team_path(transfer_project),
        params: {transfer_project: {team: "regional_casework_services"}}

      expect(response).to redirect_to(project_internal_contacts_path(transfer_project))

      conversion_project = create(:conversion_project)

      put project_internal_contacts_team_path(conversion_project),
        params: {conversion_project: {team: "regional_casework_services"}}

      expect(response).to redirect_to(project_internal_contacts_path(conversion_project))
    end
  end

  def mock_session_with_return_url(url)
    fake_session = double("session")
    allow(fake_session).to receive(:[]).with(:return_url).and_return(url)
    allow_any_instance_of(described_class).to receive(:session).and_return(fake_session)
    fake_session
  end
end
