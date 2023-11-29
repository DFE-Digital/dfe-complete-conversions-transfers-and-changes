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
    not_applicable_for_a_transfer
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

    tasks_data = double(Conversion::TasksData, sponsored_support_grant_type: :intermidiate, sponsored_support_grant_not_applicable?: false)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.sponsored_grant_type).to eql "intermidiate"

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

  it "presents all conditions met" do
    project = double(Conversion::Project, all_conditions_met: true)

    presenter = described_class.new(project)

    expect(presenter.all_conditions_met).to eql "yes"
  end

  it "presents all conditions met when it has not been met (nil)" do
    project = double(Conversion::Project, all_conditions_met: nil)

    presenter = described_class.new(project)

    expect(presenter.all_conditions_met).to eql "no"
  end

  it "presents all conditions met when it has not been met (false)" do
    project = double(Conversion::Project, all_conditions_met: false)

    presenter = described_class.new(project)

    expect(presenter.all_conditions_met).to eql "no"
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
    user = double(Contact::Project, email: "main.contact@education.gov.uk")
    project = double(Conversion::Project, main_contact: user)

    presenter = described_class.new(project)

    expect(presenter.main_contact_email).to eql "main.contact@education.gov.uk"
  end

  it "presents the main contact name" do
    user = double(Contact::Project, name: "Bob Robertson")
    project = double(Conversion::Project, main_contact: user)

    presenter = described_class.new(project)

    expect(presenter.main_contact_name).to eql "Bob Robertson"
  end

  it "presents the main contact title" do
    user = double(Contact::Project, title: "Very important person")
    project = double(Conversion::Project, main_contact: user)

    presenter = described_class.new(project)

    expect(presenter.main_contact_title).to eql "Very important person"
  end

  it "handles a project without a main contact" do
    project = double(Conversion::Project, main_contact: nil)

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
      project = create(:conversion_project)

      presenter = described_class.new(project)

      expect(presenter.link_to_project).to eql "https://www.complete.education.gov.uk/projects/#{project.id}"
    end
  end

  it "presents the project region" do
    project = build(:conversion_project)

    presenter = described_class.new(project)

    expect(presenter.region).to eql "London"
  end

  context "when the proposed capacity of the academy is not applicable" do
    it "returns not applicable" do
      tasks_data = build(:conversion_tasks_data, proposed_capacity_of_the_academy_not_applicable: true)
      project = build(:conversion_project, tasks_data: tasks_data)

      presenter = described_class.new(project)

      expect(presenter.reception_to_six_years).to eql("Not applicable")
      expect(presenter.seven_to_eleven_years).to eql("Not applicable")
      expect(presenter.twelve_or_above_years).to eql("Not applicable")
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

  def not_applicable_for_a_transfer
    project = build(:transfer_project)

    presenter = described_class.new(project)

    expect(presenter.academy_order_type).to eql "not applicable"
  end
end
