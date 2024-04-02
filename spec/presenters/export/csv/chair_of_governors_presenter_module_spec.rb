require "rails_helper"

RSpec.describe Export::Csv::ChairOfGovernorsPresenterModule do
  before do
    mock_successful_api_response_to_create_any_project
  end

  describe "#chair_of_governors_name" do
    context "when there is a contact" do
      it "presents the name of the contact" do
        contact = build(:project_contact)
        project = build(:conversion_project, chair_of_governors_contact: contact)

        presenter = Export::Csv::ProjectPresenter.new(project)

        expect(presenter.chair_of_governors_name).to eq contact.name
      end
    end

    context "when there is no contact" do
      it "presents nothing" do
        project = build(:conversion_project)

        presenter = Export::Csv::ProjectPresenter.new(project)

        expect(presenter.chair_of_governors_name).to be_nil
      end
    end
  end

  describe "#chair_of_governors_email" do
    context "when there is a contact" do
      it "presents the name of the contact" do
        contact = build(:project_contact)
        project = build(:conversion_project, chair_of_governors_contact: contact)

        presenter = Export::Csv::ProjectPresenter.new(project)

        expect(presenter.chair_of_governors_email).to eq contact.email
      end
    end

    context "when there is no contact" do
      it "presents nothing" do
        project = build(:conversion_project)

        presenter = Export::Csv::ProjectPresenter.new(project)

        expect(presenter.chair_of_governors_name).to be_nil
      end
    end
  end
end
