require "rails_helper"

RSpec.describe InternalContacts::EditAssignedUserForm, type: :model do
  before do
    mock_all_academies_api_responses
  end

  it "can be initialized with just a project" do
    user = create(:user, :caseworker)
    project = create(:conversion_project, assigned_to: user)

    result = described_class.new_from_project(project)

    expect(result.project).to eql project
    expect(result.user).to eql user
  end

  it "can be initialized with attributes" do
    user = create(:user, :caseworker, email: "case.worker@education.gov.uk")
    project = create(:conversion_project, assigned_to: user)

    result = described_class.new({email: user.email, project: project})

    expect(result.project).to eql project
    expect(result.user).to eql user
  end

  describe "validations" do
    describe "email" do
      it "is required" do
        project = create(:conversion_project, assigned_to: nil)

        result = described_class.new_from_project(project)

        expect(result).to be_invalid
      end

      it "must be an @education.gov.uk address" do
        user = create(:user, :caseworker)
        project = create(:conversion_project, assigned_to: user)
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

      it "must be an assignable user i.e. one that can be assigned to projects" do
        user = create(:user, :service_support)
        project = create(:conversion_project, assigned_to: user)

        result = described_class.new_from_project(project)

        expect(result).to be_invalid
      end
    end
  end

  describe "updating" do
    context "when the form is valid" do
      it "updates the project and returns true" do
        user = create(:user, :caseworker)
        project = create(:conversion_project, assigned_to: nil)

        result = described_class.new({email: user.email, project: project}).update

        expect(project.reload.assigned_to).to eql user
        expect(result).to be true
      end
    end

    context "when the form is invalid" do
      it "does not update the project and returns false" do
        user = create(:user, :service_support)
        project = create(:conversion_project, assigned_to: nil)

        result = described_class.new({email: user.email, project: project}).update

        expect(project.reload.assigned_to).to be_nil
        expect(result).to be false
      end
    end
  end

  describe "emailing" do
    context "when the form is valid" do
      it "sends an email to the new assignee" do
        user = create(:user, :caseworker)
        project = create(:conversion_project, assigned_to: user)
        allow(AssignedToMailer).to receive(:assigned_notification).and_call_original

        described_class.new({email: user.email, project: project}).update

        expect(AssignedToMailer).to have_received(:assigned_notification).once
      end

      context "but the user is not active" do
        it "does not send an email" do
          user = create(:user, :caseworker, active: false)
          project = create(:conversion_project, assigned_to: user)
          allow(AssignedToMailer).to receive(:assigned_notification).and_call_original

          described_class.new({email: user.email, project: project}).update

          expect(AssignedToMailer).not_to have_received(:assigned_notification)
        end
      end
    end

    context "when the form is invalid" do
      it "does not send an email" do
        user = create(:user, :service_support)
        project = create(:conversion_project, assigned_to: user)
        allow(AssignedToMailer).to receive(:assigned_notification).and_call_original

        described_class.new({email: user.email, project: project}).update

        expect(AssignedToMailer).not_to have_received(:assigned_notification)
      end
    end
  end
end
