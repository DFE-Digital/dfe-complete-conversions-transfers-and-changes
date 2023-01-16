class Conversion::Voluntary::Details < Conversion::Details
  def route
    I18n.t("conversion_project.voluntary.route")
  end
end
