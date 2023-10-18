module EnvironmentBannerHelper
  ENVIRONMENT_COLOURS = {
    local_development: "purple",
    development: "turquoise",
    test: "orange"
  }.freeze.with_indifferent_access

  def environment_banner
    return if ENVIRONMENT_COLOURS.keys.none?(user_env)

    govuk_tag(
      text: "#{user_env.tr("_", " ").upcase} ENVIRONMENT",
      colour: ENVIRONMENT_COLOURS[user_env],
      classes: "environment-banner"
    )
  end

  private def user_env
    ENV.fetch("USER_ENV", "local_development")
  end
end
