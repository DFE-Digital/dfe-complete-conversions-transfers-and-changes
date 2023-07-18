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
    tasks_data = double(Conversion::TasksData, conditions_met_confirm_all_conditions_met: true)
    project = double(Conversion::Project, tasks_data: tasks_data)

    presenter = described_class.new(project)

    expect(presenter.all_conditions_met).to eql "yes"
  end

  it "presents all conditions met when it has not been met" do
    tasks_data = double(Conversion::TasksData, conditions_met_confirm_all_conditions_met: nil)
    project = double(Conversion::Project, tasks_data: tasks_data)

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
end