module FeatureHelpers
  def sign_in_with_user(user)
    mock_successful_authentication(user.email)
    visit sign_in_path
    click_button(I18n.t("sign_in.button"))
  end
end
