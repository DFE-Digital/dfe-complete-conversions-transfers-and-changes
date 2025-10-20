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
      allow_any_instance_of(Your::ProjectsController).to receive(:current_user_id).and_return(user.id)
    end

    it "loads the requested page" do
      get root_path

      expect(response).to redirect_to in_progress_your_projects_path
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

  it "updates the latest_session column on the user" do
    freeze_time
    mock_successful_authentication(user.email)

    get "/auth/azure_activedirectory_v2/callback"
    expect(user.reload.latest_session).to eq(DateTime.now)
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

  context "when user is resolved by ADID" do
    it "logs in user even if email has changed" do
      # User created with original email and ADID
      user = create(:user, email: "original@education.gov.uk", active_directory_user_id: "test-user-id")

      # Azure sends new email but same ADID (email was renamed)
      mock_successful_authentication("renamed@education.gov.uk")

      get "/auth/azure_activedirectory_v2/callback"

      # Should login successfully using ADID match
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
    end

    it "updates group IDs on login" do
      user = create(:user, active_directory_user_id: "test-user-id")
      new_groups = ["group-1", "group-2"]

      mock_successful_authentication(user.email, new_groups)

      get "/auth/azure_activedirectory_v2/callback"

      expect(user.reload.active_directory_user_group_ids).to eq(new_groups)
    end
  end

  context "when multiple active users have the same ADID" do
    it "rejects login and shows duplicate user message" do
      create(:user, email: "user1@education.gov.uk", active_directory_user_id: "duplicate-adid")
      create(:user, :caseworker, active_directory_user_id: "duplicate-adid")

      OmniAuth.config.mock_auth[:azure_activedirectory_v2] = OmniAuth::AuthHash.new({
        info: {email: "user1@education.gov.uk"},
        uid: "duplicate-adid",
        extra: {raw_info: {groups: []}}
      })
      OmniAuth.config.test_mode = true

      get "/auth/azure_activedirectory_v2/callback"

      expect(request).to redirect_to(sign_in_path)
      expect(flash.alert).to eq(I18n.t("duplicate_user.message"))
      expect(session[:user_id]).to be_nil
    end
  end

  context "when no ADID match, fallback to email" do
    it "finds user by email when ADID has no match" do
      user = create(:user, email: "user@education.gov.uk", active_directory_user_id: nil)

      mock_successful_authentication(user.email)

      get "/auth/azure_activedirectory_v2/callback"

      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
    end

    it "assigns ADID to user found by email" do
      user = create(:user, email: "user@education.gov.uk", active_directory_user_id: nil)

      mock_successful_authentication(user.email)

      get "/auth/azure_activedirectory_v2/callback"

      expect(user.reload.active_directory_user_id).to eq("test-user-id")
    end
  end
end
