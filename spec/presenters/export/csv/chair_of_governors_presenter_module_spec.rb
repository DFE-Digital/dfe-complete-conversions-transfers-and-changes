require "rails_helper"

RSpec.describe Export::Csv::ChairOfGovernorsPresenterModule do
  before do
    mock_successful_api_response_to_create_any_project
  end

  context "when there is a contact" do
    it "presents the name and email of the contact" do
      contact = build(:project_contact)
      project = build(:conversion_project)
      KeyContacts.create(project: project, chair_of_governors: contact)

      presenter = Export::Csv::ProjectPresenter.new(project)

      expect(presenter.chair_of_governors_name).to eq contact.name
      expect(presenter.chair_of_governors_email).to eq contact.email
    end
  end

  context "when there is no key contacts" do
    it "presents nothing" do
      project = build(:conversion_project)

      presenter = Export::Csv::ProjectPresenter.new(project)

      expect(presenter.chair_of_governors_name).to be_nil
      expect(presenter.chair_of_governors_name).to be_nil
    end
  end

  context "when there is no contact" do
    it "presents nothing" do
      project = build(:conversion_project)
      KeyContacts.create(project: project)

      presenter = Export::Csv::ProjectPresenter.new(project)

      expect(presenter.chair_of_governors_name).to be_nil
      expect(presenter.chair_of_governors_name).to be_nil
    end
  end
end
