require "rails_helper"

RSpec.describe InternalContacts::EditAddedByUserForm, type: :model do
  before do
    mock_all_academies_api_responses
  end

  it "can be initialized with just a project" do
    user = create(:user, :regional_delivery_officer)
    project = create(:conversion_project, regional_delivery_officer: user)

    result = described_class.new_from_project(project)

    expect(result.project).to eql project
    expect(result.user).to eql user
  end

  it "can be initialized with attributes" do
    user = create(:user, :regional_delivery_officer, email: "case.worker@education.gov.uk")
    project = create(:conversion_project)

    result = described_class.new({email: user.email, project: project})

    expect(result.project).to eql project
    expect(result.user).to eql user
  end

  describe "validations" do
    describe "email" do
      it "must be an @education.gov.uk address" do
        user = create(:user, :caseworker)
        project = create(:conversion_project, regional_delivery_officer: user)
        allow(user).to receive(:email).and_return("case.worker@other-domain.gov.uk")

        result = described_class.new_from_project(project)

        expect(result).to be_invalid
      end

      it "must be a known email address" do
        unknown_email = "unknown.email@education.gov.uk"
        project = create(:conversion_project)

        result = described_class.new({email: unknown_email, project: project})

        expect(result).to be_invalid
      end

      it "must be the right kind of user, i.e. one who can add a project" do
        user = create(:user, :service_support)
        project = create(:conversion_project, regional_delivery_officer: user)

        result = described_class.new_from_project(project)

        expect(result).to be_invalid
      end
    end
  end

  describe "updating" do
    context "when the form is valid" do
      it "updates the project and returns true" do
        user = create(:user, :caseworker)
        project = create(:conversion_project)

        result = described_class.new({email: user.email, project: project}).update

        expect(project.reload.regional_delivery_officer).to eql user
        expect(result).to be true
      end
    end

    context "when the form is invalid" do
      it "does not update the project and returns false" do
        user = create(:user, :regional_delivery_officer)
        project = create(:conversion_project, regional_delivery_officer: user)

        result = described_class.new({email: "invlalid@email.address", project: project}).update

        expect(project.reload.regional_delivery_officer).to eql(user)
        expect(result).to be false
      end
    end
  end
end
