require "rails_helper"

RSpec.describe "Sign in" do
  let(:user) { create(:user, :caseworker) }

  context "when the user is unauthenticated" do
    it "redirects them to the sign in page and shows a helpful message" do
      get root_path

      expect(request).to redirect_to(sign_in_path)
      expect(flash.to_h.values).to include I18n.t("sign_in.message.unauthenticated")
    end
  end

  context "when the user is authenticated" do
    before do
      mock_successful_authentication(user.email)
      allow_any_instance_of(RootController).to receive(:current_user_id).and_return(user.id)
      allow_any_instance_of(User::ProjectsController).to receive(:current_user_id).and_return(user.id)
    end

    it "loads the requested page" do
      get root_path

      expect(response).to redirect_to in_progress_user_projects_path
    end
  end

  it "copies the active directory id to the user" do
    mock_successful_authentication(user.email)

    get "/auth/azure_activedirectory_v2/callback"

    expect(user.reload.active_directory_user_id).to include("test-user-id")
  end

  it "copies the Active Directory group ids to the User" do
    mock_successful_authentication(user.email)

    get "/auth/azure_activedirectory_v2/callback"

    expect(user.reload.active_directory_user_group_ids).to be_a(Array)
    expect(user.reload.active_directory_user_group_ids).to include("test-group-id-one")
    expect(user.reload.active_directory_user_group_ids).to include("test-group-id-one")
  end

  it "updates the active directory group ids when they have changed" do
    user = create(:user, active_directory_user_group_ids: ["test-group-id-one", "test-group-id-two"])
    test_group_ids = ["test-group-id-one", "test-group-id-three"]
    mock_successful_authentication(user.email, test_group_ids)

    get "/auth/azure_activedirectory_v2/callback"

    expect(user.reload.active_directory_user_group_ids).to eql(test_group_ids)
  end

  context "when the users is not known by the application" do
    before { mock_successful_authentication("user@education.gov.uk") }

    it "redirects to the sign in page and shows a helpful message" do
      get "/auth/azure_activedirectory_v2/callback"

      expect(request).to redirect_to(sign_in_path)
      expect(flash.to_h.values).to include I18n.t("unknown_user.message", email_address: "user@education.gov.uk")
    end
  end

  context "but the user is inactive" do
    it "redirects to the sign in view and shows a helpful message" do
      inactive_user = create(:inactive_user)
      mock_successful_authentication(inactive_user.email)

      get "/auth/azure_activedirectory_v2/callback"

      expect(request).to redirect_to(sign_in_path)
      expect(flash.notice).to include("inactive")
      expect(flash.notice).to include(inactive_user.email)
    end
  end
end
