class Export::Csv::ProjectPresenter
  include Export::Csv::SchoolPresenterModule
  include Export::Csv::AcademyPresenterModule
  include Export::Csv::DirectorOfChildServicesPresenterModule
  include Export::Csv::IncomingTrustPresenterModule
  include Export::Csv::LocalAuthorityPresenterModule
  include Export::Csv::MpPresenterModule

  def initialize(project)
    @project = project
  end

  def project_type
    return I18n.t("export.csv.project.values.project_type.conversion") if @project.is_a?(Conversion::Project)
    return I18n.t("export.csv.project.values.project_type.transfer") if @project.is_a?(Transfer::Project)
  end

  def conversion_date
    return I18n.t("export.csv.project.values.unconfirmed") if @project.conversion_date_provisional?

    @project.conversion_date.to_fs(:csv)
  end

  def all_conditions_met
    if @project.all_conditions_met.nil?
      return I18n.t("export.csv.project.values.no")
    end

    I18n.t("export.csv.project.values.yes")
  end

  def risk_protection_arrangement
    if @project.tasks_data.risk_protection_arrangement_option.nil?
      return I18n.t("export.csv.project.values.unconfirmed")
    end

    I18n.t("export.csv.project.values.#{@project.tasks_data.risk_protection_arrangement_option}")
  end

  def advisory_board_date
    @project.advisory_board_date.to_fs(:csv)
  end

  def academy_order_type
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Transfer::Project)
    return I18n.t("export.csv.project.values.directive_academy_order") if @project.directive_academy_order?

    I18n.t("export.csv.project.values.academy_order")
  end

  def two_requires_improvement
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Transfer::Project)
    return I18n.t("export.csv.project.values.yes") if @project.two_requires_improvement?

    I18n.t("export.csv.project.values.no")
  end

  def sponsored_grant_type
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Transfer::Project)
    return I18n.t("export.csv.project.values.not_applicable") if @project.tasks_data.sponsored_support_grant_not_applicable?
    return I18n.t("export.csv.project.values.unconfirmed") if @project.tasks_data.sponsored_support_grant_type.nil?

    I18n.t("export.csv.project.values.sponsored_grant_type.#{@project.tasks_data.sponsored_support_grant_type}")
  end

  def assigned_to_name
    @project.assigned_to.full_name
  end

  def assigned_to_email
    @project.assigned_to.email
  end
end
