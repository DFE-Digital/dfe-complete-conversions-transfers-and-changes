class Conversion::Involuntary::Details < Conversion::Details
  WORKFLOW_PATH = Rails.root.join("app", "workflows", "lists", "conversion", "involuntary").freeze

  def route
    I18n.t("conversion_project.involuntary.route")
  end
end
