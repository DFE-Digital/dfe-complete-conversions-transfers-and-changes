class Export::Csv::ProjectPresenter
  include Export::Csv::SchoolPresenterModule
  include Export::Csv::AcademyPresenterModule
  include Export::Csv::DirectorOfChildServicesPresenterModule
  include Export::Csv::IncomingTrustPresenterModule
  include Export::Csv::OutgoingTrustPresenterModule
  include Export::Csv::LocalAuthorityPresenterModule
  include Export::Csv::MpPresenterModule

  def initialize(project)
    @project = project
  end

  def reception_to_six_years
    return "Not applicable" if @project.tasks_data.proposed_capacity_of_the_academy_not_applicable
    @project.tasks_data.proposed_capacity_of_the_academy_reception_to_six_years
  end

  def seven_to_eleven_years
    return "Not applicable" if @project.tasks_data.proposed_capacity_of_the_academy_not_applicable
    @project.tasks_data.proposed_capacity_of_the_academy_seven_to_eleven_years
  end

  def twelve_or_above_years
    return "Not applicable" if @project.tasks_data.proposed_capacity_of_the_academy_not_applicable
    @project.tasks_data.proposed_capacity_of_the_academy_twelve_or_above_years
  end

  def project_type
    return I18n.t("export.csv.project.values.project_type.conversion") if @project.is_a?(Conversion::Project)
    I18n.t("export.csv.project.values.project_type.transfer") if @project.is_a?(Transfer::Project)
  end

  def conversion_date
    return I18n.t("export.csv.project.values.unconfirmed") if @project.conversion_date_provisional?

    @project.conversion_date.to_fs(:csv)
  end

  def transfer_date
    return I18n.t("export.csv.project.values.unconfirmed") if @project.significant_date_provisional?

    @project.significant_date.to_fs(:csv)
  end

  def all_conditions_met
    if @project.all_conditions_met.nil?
      return I18n.t("export.csv.project.values.no")
    end

    I18n.t("export.csv.project.values.#{@project.all_conditions_met}")
  end

  alias_method :authority_to_proceed, :all_conditions_met

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
    return I18n.t("export.csv.project.values.yes") if @project.two_requires_improvement?

    I18n.t("export.csv.project.values.no")
  end

  def financial_safeguarding_governance_issues
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Conversion::Project)

    return I18n.t("export.csv.project.values.yes") if @project.tasks_data.financial_safeguarding_governance_issues

    I18n.t("export.csv.project.values.no")
  end

  def inadequate_ofsted
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Conversion::Project)

    return I18n.t("export.csv.project.values.yes") if @project.tasks_data.inadequate_ofsted

    I18n.t("export.csv.project.values.no")
  end

  def outgoing_trust_to_close
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Conversion::Project)

    return I18n.t("export.csv.project.values.yes") if @project.tasks_data.outgoing_trust_to_close

    I18n.t("export.csv.project.values.no")
  end

  def bank_details_changing
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Conversion::Project)

    return I18n.t("export.csv.project.values.yes") if @project.tasks_data.bank_details_changing_yes_no

    I18n.t("export.csv.project.values.no")
  end

  def request_new_urn_and_record
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Conversion::Project)
    return I18n.t("export.csv.project.values.not_applicable") if @project.tasks_data.request_new_urn_and_record_not_applicable

    if @project.tasks_data.request_new_urn_and_record_complete && @project.tasks_data.request_new_urn_and_record_receive && @project.tasks_data.request_new_urn_and_record_give
      I18n.t("export.csv.project.values.confirmed")
    else
      I18n.t("export.csv.project.values.unconfirmed")
    end
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

  def main_contact_name
    return unless @project.main_contact_id
    contact = Contact::Project.find(@project.main_contact_id)
    contact&.name
  end

  def main_contact_email
    return unless @project.main_contact_id
    contact = Contact::Project.find(@project.main_contact_id)
    contact&.email
  end

  def main_contact_title
    return unless @project.main_contact_id
    contact = Contact::Project.find(@project.main_contact_id)
    contact&.title
  end

  def region
    I18n.t("project.region.#{@project.region}")
  end

  def school_phase
    @project.establishment&.phase
  end

  def link_to_project
    "https://#{ENV.fetch("HOSTNAME", "localhost:3000")}/projects/#{@project.id}"
  end

  def added_by_email
    @project.regional_delivery_officer&.email
  end

  def academy_surplus_deficit
    return if @project.is_a?(Conversion::Project)
    return I18n.t("export.csv.project.values.not_applicable") if @project.tasks_data.check_and_confirm_financial_information_not_applicable?
    @project.tasks_data.check_and_confirm_financial_information_academy_surplus_deficit
  end

  def trust_surplus_deficit
    return if @project.is_a?(Conversion::Project)
    return I18n.t("export.csv.project.values.not_applicable") if @project.tasks_data.check_and_confirm_financial_information_not_applicable?
    @project.tasks_data.check_and_confirm_financial_information_trust_surplus_deficit
  end

  def diocese_name
    @project.establishment.diocese_name
  end

  def diocese_contact_name
    return if @project.contacts.where(category: "diocese").blank?

    @project.contacts.where(category: "diocese").pluck(:name).join(", ")
  end

  def diocese_contact_email
    return if @project.contacts.where(category: "diocese").blank?

    @project.contacts.where(category: "diocese").pluck(:email).join(", ")
  end
end
