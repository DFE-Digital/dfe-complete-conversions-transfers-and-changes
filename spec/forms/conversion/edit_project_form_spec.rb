require "rails_helper"

RSpec.describe Conversion::EditProjectForm, type: :model do
  let(:project) {
    build(
      :conversion_project,
      assigned_to: user,
      advisory_board_date: Date.new(2023, 12, 1),
      directive_academy_order: false
    )
  }
  let(:user) { build(:user, :caseworker) }

  subject { Conversion::EditProjectForm.new_from_project(project, user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
  end

  describe "#update" do
    describe "the incoming trust UKPRN" do
      it "can be changed" do
        updated_params = {incoming_trust_ukprn: "12345678"}

        subject.update(updated_params)

        expect(project.incoming_trust_ukprn).to eql 12345678
      end

      it "cannot be invalid" do
        updated_params = {incoming_trust_ukprn: "2461810"}

        expect(subject.update(updated_params)).to be false
        expect(project.incoming_trust_ukprn).to eql 10061021
      end

      it "the trust must exist" do
        mock_academies_api_trust_not_found(ukprn: 12345678)

        updated_params = {incoming_trust_ukprn: "12345678"}

        expect(subject.update(updated_params)).to be false
        expect(project.incoming_trust_ukprn).to eql 10061021
      end
    end

    describe "the advisory board date" do
      it "can be changed" do
        updated_params = {
          "advisory_board_date(3i)" => "1",
          "advisory_board_date(2i)" => "1",
          "advisory_board_date(1i)" => "2024"
        }

        subject.update(updated_params)

        expect(project.advisory_board_date).to eql Date.new(2024, 1, 1)
      end

      it "cannot be invalid" do
        updated_params = {
          "advisory_board_date(3i)" => "32",
          "advisory_board_date(2i)" => "1",
          "advisory_board_date(1i)" => "2024"
        }

        expect(subject.update(updated_params)).to be false
        expect(project.advisory_board_date).to eql project.advisory_board_date
      end
    end

    describe "advisory board conditions" do
      it "can be changed" do
        updated_params = {advisory_board_conditions: "Some conditions."}

        subject.update(updated_params)

        expect(project.advisory_board_conditions).to eql "Some conditions."
      end

      it "can be blank, which clears the value" do
        updated_params = {advisory_board_conditions: ""}

        subject.update(updated_params)

        expect(project.advisory_board_conditions).to eql ""
      end
    end

    describe "Establishment SharePoint link" do
      it "can be changed" do
        updated_params = {establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link"}

        subject.update(updated_params)

        expect(project.establishment_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link")
      end

      it "cannot be invalid" do
        updated_params = {establishment_sharepoint_link: "https://some-other-domain.com/establishment-folder-updated-link"}

        expect(subject.update(updated_params)).to be false
        expect(project.establishment_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/establishment-folder")
      end

      it "cannot be empty" do
        updated_params = {establishment_sharepoint_link: ""}

        expect(subject.update(updated_params)).to be false
        expect(project.establishment_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/establishment-folder")
      end
    end

    describe "Incoming trust SharePoint link" do
      it "can be changed" do
        updated_params = {incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link"}

        subject.update(updated_params)

        expect(project.incoming_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link")
      end

      it "cannot be invalid" do
        updated_params = {incoming_trust_sharepoint_link: "https://some-other-domain.com/incoming-trust-folder-updated-link"}

        expect(subject.update(updated_params)).to be false
        expect(project.incoming_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/incoming-trust-folder")
      end

      it "cannot be empty" do
        updated_params = {incoming_trust_sharepoint_link: ""}

        expect(subject.update(updated_params)).to be false
        expect(project.incoming_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/incoming-trust-folder")
      end
    end

    describe "Directive academy order" do
      it "can be changed" do
        updated_params = {directive_academy_order: "true"}

        subject.update(updated_params)

        expect(project.directive_academy_order).to be true

        updated_params = {directive_academy_order: "false"}

        subject.update(updated_params)

        expect(project.directive_academy_order).to be false
      end
    end

    describe "two requires improvement" do
      it "can be changed" do
        updated_params = {two_requires_improvement: "true"}

        subject.update(updated_params)

        expect(project.two_requires_improvement).to be true

        updated_params = {two_requires_improvement: "false"}

        subject.update(updated_params)

        expect(project.two_requires_improvement).to be false
      end
    end

    describe "hand over to RCS team" do
      it "emails the RCS team leaders if the field is updated" do
        team_leader = create(:user, :team_leader)

        updated_params = {assigned_to_regional_caseworker_team: "true", handover_note_body: "Some notes"}

        subject.update(updated_params)

        expect(ActionMailer::MailDeliveryJob)
          .to(have_been_enqueued.on_queue("default")
                                .with("TeamLeaderMailer", "new_conversion_project_created", "deliver_now", args: [team_leader, project]))
      end

      it "does not unassign the project's assigned user" do
        updated_params = {assigned_to_regional_caseworker_team: "true"}

        subject.update(updated_params)

        expect(project.reload.assigned_to).to eq(user)
      end
    end

    describe "the group reference number" do
      context "when the group does not exist" do
        it "creates the group and associate the project" do
          expect { subject.update({group_id: "GRP_12345678"}) }.to change { ProjectGroup.count }.by(1)

          expect(project.group.group_identifier).to eql "GRP_12345678"
        end
      end

      context "when the group exists" do
        it "associates the project" do
          create(:project_group, group_identifier: "GRP_12345678", trust_ukprn: project.incoming_trust_ukprn)

          expect { subject.update({group_id: "GRP_12345678"}) }.not_to change { ProjectGroup.count }

          expect(project.group.group_identifier).to eql "GRP_12345678"
        end
      end

      context "when set to empty" do
        it "un-sets the project association" do
          create(:project_group, group_identifier: "GRP_12345678", trust_ukprn: project.incoming_trust_ukprn)

          expect { subject.update({group_id: ""}) }.not_to change { ProjectGroup.count }

          expect(project.group).to be_nil
        end
      end
    end
  end
end
