class Export::Csv::ProjectPresenter
  include Export::Csv::SchoolPresenterModule
  include Export::Csv::AcademyPresenterModule
  include Export::Csv::DirectorOfChildServicesPresenterModule
  include Export::Csv::IncomingTrustPresenterModule
  include Export::Csv::OutgoingTrustPresenterModule
  include Export::Csv::LocalAuthorityPresenterModule
  include Export::Csv::MpPresenterModule
  include Export::Csv::ChairOfGovernorsPresenterModule

  def initialize(project)
    @project = project
    @contacts_fetcher = ContactsFetcherService.new(@project)
    @local_authority = @project.local_authority
    @academy = @project.academy if @project.academy_urn.present?
    @director_of_child_services = @contacts_fetcher.director_of_child_services
  end

  def reception_to_six_years
    return I18n.t("export.csv.project.values.not_applicable") if @project.tasks_data.proposed_capacity_of_the_academy_not_applicable
    @project.tasks_data.proposed_capacity_of_the_academy_reception_to_six_years
  end

  def seven_to_eleven_years
    return I18n.t("export.csv.project.values.not_applicable") if @project.tasks_data.proposed_capacity_of_the_academy_not_applicable
    @project.tasks_data.proposed_capacity_of_the_academy_seven_to_eleven_years
  end

  def twelve_or_above_years
    return I18n.t("export.csv.project.values.not_applicable") if @project.tasks_data.proposed_capacity_of_the_academy_not_applicable
    @project.tasks_data.proposed_capacity_of_the_academy_twelve_or_above_years
  end

  def project_type
    return I18n.t("export.csv.project.values.project_type.conversion") if @project.is_a?(Conversion::Project)
    I18n.t("export.csv.project.values.project_type.transfer") if @project.is_a?(Transfer::Project)
  end

  def provisional_date
    @project.provisional_date.to_fs(:csv)
  end
  alias_method :provisional_conversion_date, :provisional_date
  alias_method :provisional_transfer_date, :provisional_date

  def conversion_date
    return I18n.t("export.csv.project.values.unconfirmed") if @project.conversion_date_provisional?

    @project.conversion_date.to_fs(:csv)
  end

  def transfer_date
    return I18n.t("export.csv.project.values.unconfirmed") if @project.significant_date_provisional?

    @project.significant_date.to_fs(:csv)
  end

  def date_academy_transferred
    return nil if @project.is_a?(Conversion::Project)
    return I18n.t("export.csv.project.values.unconfirmed") if @project.tasks_data.confirm_date_academy_transferred_date_transferred.nil?

    @project.tasks_data.confirm_date_academy_transferred_date_transferred.to_fs(:csv)
  end

  def date_academy_opened
    return nil if @project.is_a?(Transfer::Project)
    return I18n.t("export.csv.project.values.unconfirmed") if @project.tasks_data.confirm_date_academy_opened_date_opened.nil?

    @project.tasks_data.confirm_date_academy_opened_date_opened.to_fs(:csv)
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
      return I18n.t("export.csv.project.values.standard")
    end

    I18n.t("export.csv.project.values.#{@project.tasks_data.risk_protection_arrangement_option}")
  end

  def risk_protection_arrangement_reason
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Transfer::Project)

    option = @project.tasks_data.risk_protection_arrangement_option
    return I18n.t("export.csv.project.values.not_applicable") if option.nil? ||
      option.eql?("standard") ||
      option.eql?("church_or_trust")

    @project.tasks_data.risk_protection_arrangement_reason
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
    return I18n.t("export.csv.project.values.sponsored_grant_type.not_eligible") if @project.tasks_data.sponsored_support_grant_not_applicable?
    return I18n.t("export.csv.project.values.unconfirmed") if @project.tasks_data.sponsored_support_grant_type.nil?

    I18n.t("export.csv.project.values.sponsored_grant_type.#{@project.tasks_data.sponsored_support_grant_type}")
  end

  def transfer_grant_level
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Conversion::Project)
    return I18n.t("export.csv.project.values.not_applicable") if @project.tasks_data.sponsored_support_grant_not_applicable?
    return I18n.t("export.csv.project.values.unconfirmed") if @project.tasks_data.sponsored_support_grant_type.nil?

    I18n.t("export.csv.project.values.sponsored_grant_type.#{@project.tasks_data.sponsored_support_grant_type}")
  end

  def assigned_to_name
    return I18n.t("export.csv.project.values.unassigned") unless @project.assigned_to.present?

    @project.assigned_to.full_name
  end

  def assigned_to_email
    return I18n.t("export.csv.project.values.unassigned") unless @project.assigned_to.present?

    @project.assigned_to.email
  end

  def assigned_to_team
    return I18n.t("export.csv.project.values.unassigned") unless @project.team.present?

    I18n.t("export.csv.project.values.team.#{@project.team}")
  end

  def main_contact_name
    return unless @project.main_contact.present?

    @project.main_contact.name
  end

  def main_contact_email
    return unless @project.main_contact.present?

    @project.main_contact.email
  end

  def main_contact_title
    return unless @project.main_contact.present?

    @project.main_contact.title
  end

  def region
    I18n.t("project.region.#{@project.region}")
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
    contacts = @contacts_fetcher.all_project_contacts_grouped
    return if contacts["diocese"].blank?

    contacts["diocese"].pluck(:name).join(",")
  end

  def diocese_contact_email
    contacts = @contacts_fetcher.all_project_contacts_grouped
    return if contacts["diocese"].blank?

    contacts["diocese"].pluck(:email).join(",")
  end

  def advisory_board_conditions
    return if @project.advisory_board_conditions.blank?

    @project.advisory_board_conditions
  end

  def completed_grant_payment_certificate_received
    return I18n.t("export.csv.project.values.unconfirmed") unless @project.tasks_data.receive_grant_payment_certificate_date_received.present?

    @project.tasks_data.receive_grant_payment_certificate_date_received.to_fs(:csv)
  end

  def solicitor_contact_name
    contacts = @contacts_fetcher.all_project_contacts_grouped
    return if contacts["solicitor"].blank?

    contacts["solicitor"].pluck(:name).join(",")
  end

  def solicitor_contact_email
    contacts = @contacts_fetcher.all_project_contacts_grouped
    return if contacts["solicitor"].blank?

    contacts["solicitor"].pluck(:email).join(",")
  end

  def project_created_by_name
    user_id = @project.regional_delivery_officer_id
    User.find_by(id: user_id)&.full_name
  end

  def project_created_by_email
    user_id = @project.regional_delivery_officer_id
    User.find_by(id: user_id)&.email
  end

  def team_managing_the_project
    I18n.t("teams.#{@project.team}")
  end

  def conversion_type
    return if @project.type == "Transfer::Project"
    return I18n.t("export.csv.project.values.form_a_mat") if @project.form_a_mat?
    I18n.t("export.csv.project.values.join_a_mat")
  end

  def transfer_type
    return if @project.type == "Conversion::Project"
    return I18n.t("export.csv.project.values.form_a_mat") if @project.form_a_mat?
    I18n.t("export.csv.project.values.join_a_mat")
  end

  def esfa_notes
    notes = @project.notes.select do |note|
      note.task_identifier.eql?("update_esfa")
    end

    return I18n.t("export.csv.project.values.none") unless notes.any?

    notes.map(&:body).join("\n\n")
  end

  def other_contact_name
    other_contact&.name
  end

  def other_contact_email
    other_contact&.email
  end

  def other_contact_role
    other_contact&.title
  end

  def declaration_of_expenditure_certificate_date_received
    return I18n.t("export.csv.project.values.not_applicable") if @project.is_a?(Conversion::Project)
    return I18n.t("export.csv.project.values.unconfirmed") unless @project.tasks_data.declaration_of_expenditure_certificate_date_received.present?

    @project.tasks_data.declaration_of_expenditure_certificate_date_received.to_fs(:csv)
  end

  private def other_contact
    @contacts_fetcher.other_contact
  end
end
