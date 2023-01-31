module FeatureHelpers
  require "axe-rspec"

  def sign_in_with_user(user)
    mock_successful_authentication(user.email)
    visit sign_in_path
    click_button(I18n.t("sign_in.button"))
  end

  # As noted in the GOVUK Design System documentation, Axe will raise a false
  # positive for the skip link, so we have to exclude it:
  #
  # https://design-system.service.gov.uk/components/skip-link/
  #
  # We also test against WCAG2.2AA
  def check_accessibility(page)
    expect(page).to be_axe_clean.excluding(".govuk-skip-link").according_to(:wcag22aa)
  end
end
