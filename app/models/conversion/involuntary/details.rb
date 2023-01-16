class Conversion::Involuntary::Details < Conversion::Details
  def route
    I18n.t("conversion_project.involuntary.route")
  end
end
