require "rails_helper"

RSpec.describe Export::Csv::ProjectPresenter do
  it "presents the project type when the project is a conversion" do
    project = build(:conversion_project)

    presenter = described_class.new(project)

    expect(presenter.project_type).to eql "Conversion"
  end

  it "presents the project type when the project is a transfer" do
    project = build(:transfer_project)

    presenter = described_class.new(project)

    expect(presenter.project_type).to eql "Transfer"
  end

  it "presents the academy order type" do
    project = build(:conversion_project, directive_academy_order: true)

    presenter = described_class.new(project)

    expect(presenter.academy_order_type).to eql "directive academy order"

    project = build(:conversion_project, directive_academy_order: false)

    presenter = described_class.new(project)

    expect(presenter.academy_order_type).to eql "academy order"
  end

  it "presents the academy order type for a transfer" do
    not_applicable_for_a_transfer
  end

  it "presents the two requires improvement value" do
    project = build(:conversion_project, two_requires_improvement: true)

    presenter = described_class.new(project)

    expect(presenter.two_requires_improvement).to eql "yes"

    project = build(:conversion_project, two_requires_improvement: false)

    presenter = described_class.new(project)

    expect(presenter.two_requires_improvement).to eql "no"
  end

  it "presents the two requires improvement value for a transfer" do
    project = build(:transfer_project, two_requires_improvement: true)

    presenter = described_class.new(project)

    expect(presenter.two_requires_improvement).to eql "yes"

    project = build(:transfer_project, two_requires_improvement: false)

    presenter = described_class.new(project)

    expect(presenter.two_requires_improvement).to eql "no"
  end

  it "presents inadequate_ofsted value for a transfer" do
    tasks_data = double(Transfer::TasksData, inadequate_ofsted: true)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.inadequate_ofsted).to eql "yes"

    tasks_data = double(Transfer::TasksData, inadequate_ofsted: false)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.inadequate_ofsted).to eql "no"
  end

  it "presents financial_safeguarding_governance_issues value for a transfer" do
    tasks_data = double(Transfer::TasksData, financial_safeguarding_governance_issues: true)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.financial_safeguarding_governance_issues).to eql "yes"

    tasks_data = double(Transfer::TasksData, financial_safeguarding_governance_issues: false)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.financial_safeguarding_governance_issues).to eql "no"
  end

  it "presents outgoing_trust_to_close value for a transfer" do
    tasks_data = double(Transfer::TasksData, outgoing_trust_to_close: true)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.outgoing_trust_to_close).to eql "yes"

    tasks_data = double(Transfer::TasksData, outgoing_trust_to_close: false)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.outgoing_trust_to_close).to eql "no"
  end

  it "presents request_new_urn_and_record value for a transfer" do
    tasks_data = double(Transfer::TasksData,
      request_new_urn_and_record_complete: true,
      request_new_urn_and_record_receive: true,
      request_new_urn_and_record_give: true,
      request_new_urn_and_record_not_applicable: false)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.request_new_urn_and_record).to eql "confirmed"

    tasks_data = double(Transfer::TasksData,
      request_new_urn_and_record_complete: false,
      request_new_urn_and_record_receive: false,
      request_new_urn_and_record_give: false,
      request_new_urn_and_record_not_applicable: false)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.request_new_urn_and_record).to eql "unconfirmed"

    tasks_data = double(Transfer::TasksData,
      request_new_urn_and_record_complete: false,
      request_new_urn_and_record_receive: false,
      request_new_urn_and_record_give: false,
      request_new_urn_and_record_not_applicable: true)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.request_new_urn_and_record).to eql "not applicable"
  end

  it "presents bank_details_changing value for a transfer" do
    tasks_data = double(Transfer::TasksData, bank_details_changing_yes_no: true)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.bank_details_changing).to eql "yes"

    tasks_data = double(Transfer::TasksData, bank_details_changing_yes_no: false)
    project = double(Transfer::Project, tasks_data: tasks_data)
    presenter = described_class.new(project)
    expect(presenter.bank_details_changing).to eql "no"
  end

  it "presents the sponsored grant type" do
    tasks_data = double(Conversion::TasksData, sponsored_support_grant_type: nil, sponsored_support_grant_not_applicable?: false)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.sponsored_grant_type).to eql "unconfirmed"

    tasks_data = double(Conversion::TasksData, sponsored_support_grant_type: :fast_track, sponsored_support_grant_not_applicable?: false)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.sponsored_grant_type).to eql "fast track"

    tasks_data = double(Conversion::TasksData, sponsored_support_grant_type: :intermediate, sponsored_support_grant_not_applicable?: false)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.sponsored_grant_type).to eql "intermediate"

    tasks_data = double(Conversion::TasksData, sponsored_support_grant_type: :sponsored, sponsored_support_grant_not_applicable?: false)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.sponsored_grant_type).to eql "sponsored"
  end

  it "presents the sponsored grant type value when it does not apply" do
    tasks_data = double(Conversion::TasksData, sponsored_support_grant_not_applicable?: true)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.sponsored_grant_type).to eql "not applicable"
  end

  it "presents the sponsored grant type value for a transfer" do
    not_applicable_for_a_transfer
  end

  it "presents the provisional date" do
    conversion_project = double(Conversion::Project, provisional_date: Date.parse("2024-1-1"), conversion_date_provisional?: true)

    conversion_presenter = described_class.new(conversion_project)

    expect(conversion_presenter.provisional_date).to eql "2024-01-01"
  end

  it "presents the conversion date" do
    project = double(Conversion::Project, conversion_date: Date.parse("2023-1-1"), conversion_date_provisional?: false)

    presenter = described_class.new(project)

    expect(presenter.conversion_date).to eql "2023-01-01"
  end

  it "presents unconfirmed when the conversion date is provisional" do
    project = double(Conversion::Project, conversion_date: Date.parse("2023-1-1"), conversion_date_provisional?: true)

    presenter = described_class.new(project)

    expect(presenter.conversion_date).to eql "unconfirmed"
  end

  it "presents the significant date (as transfer date)" do
    project = double(Transfer::Project, significant_date: Date.parse("2023-1-1"), significant_date_provisional?: false)

    presenter = described_class.new(project)

    expect(presenter.transfer_date).to eql "2023-01-01"
  end

  it "presents unconfirmed when the significant date is provisional" do
    project = double(Transfer::Project, significant_date: Date.parse("2023-1-1"), significant_date_provisional?: true)

    presenter = described_class.new(project)

    expect(presenter.transfer_date).to eql "unconfirmed"
  end

  it "presents all conditions met" do
    project = double(Conversion::Project, all_conditions_met: true)

    presenter = described_class.new(project)

    expect(presenter.all_conditions_met).to eql "yes"
  end

  it "presents authority to proceed, which is the name for 'all conditions met' for Transfer projects" do
    project = double(Transfer::Project, all_conditions_met: true)

    presenter = described_class.new(project)

    expect(presenter.authority_to_proceed).to eql "yes"
  end

  it "presents authority to proceed (all conditions met for Transfer projects) when it has not been met (nil)" do
    project = double(Transfer::Project, all_conditions_met: nil)

    presenter = described_class.new(project)

    expect(presenter.authority_to_proceed).to eql "no"
  end

  it "presents authority to proceed (all conditions met for Transfer projects) when it has not been met (false)" do
    project = double(Transfer::Project, all_conditions_met: false)

    presenter = described_class.new(project)

    expect(presenter.authority_to_proceed).to eql "no"
  end

  it "presents all risk protection arrangement when it is standard" do
    tasks_data = double(Conversion::TasksData, risk_protection_arrangement_option: :standard)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.risk_protection_arrangement).to eql "standard"
  end

  it "presents all risk protection arrangement when it is church/trust" do
    tasks_data = double(Conversion::TasksData, risk_protection_arrangement_option: :church_or_trust)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.risk_protection_arrangement).to eql "church or trust"
  end

  it "presents all risk protection arrangement when it is commercial" do
    tasks_data = double(Conversion::TasksData, risk_protection_arrangement_option: :commercial)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.risk_protection_arrangement).to eql "commercial"
  end

  it "presents all risk protection arrangement when it is not yet confirmed" do
    tasks_data = double(Conversion::TasksData, risk_protection_arrangement_option: nil)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.risk_protection_arrangement).to eql "unconfirmed"
  end

  describe "#assigned_to_name" do
    context "when the project is assigned to a user" do
      it "returns the name of the user the project is assigned to" do
        user = double(User, full_name: "Assigned User")
        project = double(Conversion::Project, assigned_to: user)

        presenter = described_class.new(project)

        expect(presenter.assigned_to_name).to eql "Assigned User"
      end
    end
    context "when the project is unassigned" do
      it "returns 'unassigned'" do
        project = double(Conversion::Project, assigned_to: nil)

        presenter = described_class.new(project)

        expect(presenter.assigned_to_name).to eql "unassigned"
      end
    end
  end

  describe "#assigned_to_email" do
    context "when the project is assigned to a user" do
      it "returns the email address of the user the project is assigned to" do
        user = double(User, email: "assigned.user@education.gov.uk")
        project = double(Conversion::Project, assigned_to: user)

        presenter = described_class.new(project)

        expect(presenter.assigned_to_email).to eql "assigned.user@education.gov.uk"
      end
    end
    context "when the project is unassigned" do
      it "returns 'unassigned'" do
        project = double(Conversion::Project, assigned_to: nil)

        presenter = described_class.new(project)

        expect(presenter.assigned_to_email).to eql "unassigned"
      end
    end
  end

  it "presents the assigned to name" do
    user = double(User, full_name: "Assigned User")
    project = double(Conversion::Project, assigned_to: user)

    presenter = described_class.new(project)

    expect(presenter.assigned_to_name).to eql "Assigned User"
  end

  it "presents the assigned to email" do
    user = double(User, email: "assigned.user@education.gov.uk")
    project = double(Conversion::Project, assigned_to: user)

    presenter = described_class.new(project)

    expect(presenter.assigned_to_email).to eql "assigned.user@education.gov.uk"
  end

  it "presents the main contact email" do
    mock_successful_api_response_to_create_any_project
    user = create(:project_contact, email: "main.contact@education.gov.uk")
    project = create(:conversion_project, main_contact_id: user.id)

    presenter = described_class.new(project)

    expect(presenter.main_contact_email).to eql "main.contact@education.gov.uk"
  end

  it "presents the main contact name" do
    mock_successful_api_response_to_create_any_project
    user = create(:project_contact, name: "Bob Robertson")
    project = create(:conversion_project, main_contact_id: user.id)

    presenter = described_class.new(project)

    expect(presenter.main_contact_name).to eql "Bob Robertson"
  end

  it "presents the main contact title" do
    mock_successful_api_response_to_create_any_project
    user = create(:project_contact, title: "Very important person")
    project = create(:conversion_project, main_contact_id: user.id)

    presenter = described_class.new(project)

    expect(presenter.main_contact_title).to eql "Very important person"
  end

  it "handles a project without a main contact" do
    mock_successful_api_response_to_create_any_project
    project = build(:conversion_project, main_contact: nil)

    presenter = described_class.new(project)

    expect(presenter.main_contact_name).to be_nil
    expect(presenter.main_contact_email).to be_nil
    expect(presenter.main_contact_title).to be_nil
  end

  it "presents the school phase" do
    mock_successful_api_response_to_create_any_project
    project = build(:conversion_project)

    presenter = described_class.new(project)

    expect(presenter.school_phase).to eql "Secondary"
  end

  it "presents the link to the project" do
    ClimateControl.modify(
      HOSTNAME: "www.complete.education.gov.uk"
    ) do
      mock_successful_api_response_to_create_any_project
      project = build(:conversion_project)

      presenter = described_class.new(project)

      expect(presenter.link_to_project).to eql "https://www.complete.education.gov.uk/projects/#{project.id}"
    end
  end

  it "presents the project region" do
    project = build(:conversion_project)

    presenter = described_class.new(project)

    expect(presenter.region).to eql "London"
  end

  it "presents who the project was added by (the Regional delivery officer)" do
    rdo = build(:regional_delivery_officer_user)
    project = build(:conversion_project, regional_delivery_officer: rdo)

    presenter = described_class.new(project)

    expect(presenter.added_by_email).to eql rdo.email
  end

  context "when the proposed capacity of the academy is not applicable" do
    it "returns not applicable" do
      tasks_data = build(:conversion_tasks_data, proposed_capacity_of_the_academy_not_applicable: true)
      project = build(:conversion_project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.reception_to_six_years).to eql("not applicable")
      expect(presenter.seven_to_eleven_years).to eql("not applicable")
      expect(presenter.twelve_or_above_years).to eql("not applicable")
    end
  end

  context "when the proposed capacity of the academy is added" do
    it "presents the proposed capacity of the academy" do
      tasks_data = build(:conversion_tasks_data, proposed_capacity_of_the_academy_reception_to_six_years: 345, proposed_capacity_of_the_academy_seven_to_eleven_years: 500, proposed_capacity_of_the_academy_twelve_or_above_years: 400)
      project = build(:conversion_project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.reception_to_six_years).to eql("345")
      expect(presenter.seven_to_eleven_years).to eql("500")
      expect(presenter.twelve_or_above_years).to eql("400")
    end
  end

  it "presents the Academy surplus/deficit financial information" do
    tasks_data = build(:transfer_tasks_data, check_and_confirm_financial_information_academy_surplus_deficit: "surplus")
    project = build(:transfer_project, tasks_data: tasks_data)

    presenter = described_class.new(project)
    expect(presenter.academy_surplus_deficit).to eq("surplus")
  end

  it "presents the Trust surplus/deficit financial information" do
    tasks_data = build(:transfer_tasks_data, check_and_confirm_financial_information_trust_surplus_deficit: "deficit")
    project = build(:transfer_project, tasks_data: tasks_data)

    presenter = described_class.new(project)
    expect(presenter.trust_surplus_deficit).to eq("deficit")
  end

  it "presents Not applicable when the surplus/deficit financial information in not applicable" do
    tasks_data = build(:transfer_tasks_data, check_and_confirm_financial_information_not_applicable: true)
    project = build(:transfer_project, tasks_data: tasks_data)

    presenter = described_class.new(project)
    expect(presenter.academy_surplus_deficit).to eq("not applicable")
  end

  it "presents the diocese name" do
    mock_successful_api_response_to_create_any_project
    project = build(:conversion_project)

    presenter = described_class.new(project)

    expect(presenter.diocese_name).to eql("Diocese of West Placefield")
  end

  it "presents the diocese contact name" do
    mock_successful_api_response_to_create_any_project
    project = create(:conversion_project)
    create(:project_contact, category: "diocese", name: "contact name", project: project)

    presenter = described_class.new(project)

    expect(presenter.diocese_contact_name).to eql("contact name")
  end

  it "presents the diocese contact email" do
    mock_successful_api_response_to_create_any_project
    project = create(:conversion_project)
    create(:project_contact, category: "diocese", email: "diocese_contact@email.com", project: project)

    presenter = described_class.new(project)

    expect(presenter.diocese_contact_email).to eql("diocese_contact@email.com")
  end

  context "when there is no diocese contact" do
    it "returns nil" do
      mock_successful_api_response_to_create_any_project
      project = build(:conversion_project)

      presenter = described_class.new(project)

      expect(presenter.diocese_contact_name).to be_nil
    end
  end

  it "presents the advisory board conditions" do
    mock_successful_api_response_to_create_any_project
    project = build(:conversion_project, advisory_board_conditions: "These are the conditions.")

    presenter = described_class.new(project)

    expect(presenter.advisory_board_conditions).to eql("These are the conditions.")
  end

  describe "#completed_grant_payment_certificate_received" do
    it "presents the completed grant payment certificate received" do
      mock_successful_api_response_to_create_any_project
      tasks_data = build(:conversion_tasks_data, receive_grant_payment_certificate_date_received: Date.new(2024, 1, 1))
      project = build(:conversion_project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.completed_grant_payment_certificate_received).to eql("2024-01-01")
    end

    it "presents unconfirmed when there is no date" do
      mock_successful_api_response_to_create_any_project
      tasks_data = build(:conversion_tasks_data, receive_grant_payment_certificate_date_received: nil)
      project = build(:conversion_project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.completed_grant_payment_certificate_received).to eql("unconfirmed")
    end
  end

  it "presents the solicitor contact name" do
    mock_successful_api_response_to_create_any_project
    project = create(:conversion_project)
    create(:project_contact, category: "solicitor", name: "solicitor contact name", project: project)

    presenter = described_class.new(project)

    expect(presenter.solicitor_contact_name).to eql("solicitor contact name")
  end

  it "presents the solicitor contact email" do
    mock_successful_api_response_to_create_any_project
    project = create(:conversion_project)
    create(:project_contact, category: "solicitor", email: "solicitor_contact@email.com", project: project)

    presenter = described_class.new(project)

    expect(presenter.solicitor_contact_email).to eql("solicitor_contact@email.com")
  end

  context "when there is no solicitor contact" do
    it "returns nil" do
      mock_successful_api_response_to_create_any_project
      project = build(:conversion_project)

      presenter = described_class.new(project)

      expect(presenter.solicitor_contact_name).to be_nil
    end
  end

  it "presents the project created by name" do
    mock_successful_api_response_to_create_any_project
    user = create(:regional_delivery_officer_user, first_name: "Joe", last_name: "Bloggs")
    project = create(:conversion_project, regional_delivery_officer: user)

    presenter = described_class.new(project)

    expect(presenter.project_created_by_name).to eql("Joe Bloggs")
  end

  it "presents the project created by email" do
    mock_successful_api_response_to_create_any_project
    user = create(:regional_delivery_officer_user, email: "joe.bloggs@education.gov.uk")
    project = create(:conversion_project, regional_delivery_officer: user)

    presenter = described_class.new(project)

    expect(presenter.project_created_by_email).to eql("joe.bloggs@education.gov.uk")
  end

  it "presents the team managing the project" do
    mock_successful_api_response_to_create_any_project
    user = create(:user, team: "london")
    project = create(:conversion_project, assigned_to_id: user)

    presenter = described_class.new(project)

    expect(presenter.team_managing_the_project).to eql("London")
  end

  it "presents the single converter conversion type" do
    mock_successful_api_response_to_create_any_project
    project = build(:conversion_project)

    presenter = described_class.new(project)
    expect(presenter.conversion_type).to eq("single converter")
  end

  it "presents the form a MAT conversion type" do
    mock_successful_api_response_to_create_any_project
    project = build(:conversion_project, :form_a_mat)

    presenter = described_class.new(project)
    expect(presenter.conversion_type).to eq("form a MAT")
  end

  it "presents the single transfer transfer type" do
    mock_successful_api_response_to_create_any_project
    project = build(:transfer_project)

    presenter = described_class.new(project)
    expect(presenter.transfer_type).to eq("single transfer")
  end

  it "presents the form a MAT transfer type" do
    mock_successful_api_response_to_create_any_project
    project = build(:transfer_project, :form_a_mat)

    presenter = described_class.new(project)
    expect(presenter.transfer_type).to eq("form a MAT")
  end

  it "presents the first 'other' contact name" do
    mock_successful_api_response_to_create_any_project
    project = create(:conversion_project)
    _contact = create(:project_contact, category: "other", project: project)

    presenter = described_class.new(project)
    expect(presenter.other_contact_name).to eq("Jo Example")
  end

  it "presents the first 'other' contact email" do
    mock_successful_api_response_to_create_any_project
    project = create(:conversion_project)
    _contact = create(:project_contact, category: "other", project: project)

    presenter = described_class.new(project)
    expect(presenter.other_contact_email).to eq("jo@example.com")
  end

  it "presents the first 'other' contact role" do
    mock_successful_api_response_to_create_any_project
    project = create(:conversion_project)
    _contact = create(:project_contact, category: "other", project: project)

    presenter = described_class.new(project)
    expect(presenter.other_contact_role).to eq("CEO of Learning")
  end

  def not_applicable_for_a_transfer
    project = build(:transfer_project)

    presenter = described_class.new(project)

    expect(presenter.academy_order_type).to eql "not applicable"
  end

  describe "#esfa_notes" do
    context "when there are no notes" do
      it "returns 'none'" do
        project = build(:conversion_project)
        project_note = build(:note, body: "This is a project note")
        allow(project).to receive(:notes).and_return([project_note])

        presenter = described_class.new(project)

        expect(presenter.esfa_notes).to eql("none")
      end
    end

    context "when there is one note" do
      it "returns the note body" do
        project = build(:conversion_project)
        project_note = build(:note, body: "This is a project note")
        note = build(:note, task_identifier: "update_esfa")

        allow(project).to receive(:notes).and_return([project_note, note])

        presenter = described_class.new(project)

        expect(presenter.esfa_notes).to eql(note.body)
      end
    end

    context "when there is more than one note" do
      it "returns the bodies of the notes in a single value" do
        project = build(:conversion_project)
        project_note = build(:note, body: "This is a project note")
        note = build(:note, task_identifier: "update_esfa")
        another_note = build(:note, body: "This is a note to give to the ESFA", task_identifier: "update_esfa")

        allow(project).to receive(:notes).and_return([note, project_note, another_note])

        presenter = described_class.new(project)

        expect(presenter.esfa_notes).to include(note.body)
        expect(presenter.esfa_notes).to include(another_note.body)
        expect(presenter.esfa_notes).not_to include(project_note.body)
      end
    end
  end
end
