module FeatureHelpers
  def sign_in_with_user(user_email_address)
    User.create!(email: user_email_address)
    mock_successful_authentication(user_email_address)
    visit sign_in_path
    click_button(I18n.t("sign_in.button"))
  end
end
