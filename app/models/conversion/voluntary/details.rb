class Conversion::Voluntary::Details < Conversion::Details
  WORKFLOW_PATH = Rails.root.join("app", "workflows", "lists", "conversion", "voluntary").freeze

  def route
    I18n.t("conversion_project.voluntary.route")
  end
end
