require "rails_helper"

RSpec.describe Transfer::EditProjectForm, type: :model do
  let(:project) do
    build(
      :transfer_project,
      outgoing_trust_ukprn: 10059062,
      incoming_trust_ukprn: 10059151,
      assigned_to: user
    )
  end
  let(:user) { build(:user, :caseworker) }

  subject { Transfer::EditProjectForm.new_from_project(project, user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
  end

  describe "#update" do
    it "raises an error if the project cannot be saved" do
      tasks_data = create(:transfer_tasks_data, inadequate_ofsted: false)
      project = create(:transfer_project, outgoing_trust_ukprn: 10059062, tasks_data: tasks_data)
      allow(project).to receive(:save!).and_raise(ActiveRecord::RecordNotSaved)

      subject = described_class.new_from_project(project, user)

      updated_params = {outgoing_trust_ukprn: "12345678", inadequate_ofsted: "true"}

      expect { subject.update(updated_params) }.to raise_error(ActiveRecord::RecordNotSaved)

      project.reload

      expect(project.outgoing_trust_ukprn).to be 10059062
      expect(project.tasks_data.inadequate_ofsted).to be false
    end

    describe "the outgoing trust UKPRN" do
      it "can be changed" do
        updated_params = {outgoing_trust_ukprn: "12345678"}

        subject.update(updated_params)

        expect(project.outgoing_trust_ukprn).to eql 12345678
      end

      it "cannot be invalid" do
        updated_params = {outgoing_trust_ukprn: "2461810"}

        expect(subject.update(updated_params)).to be false
        expect(project.outgoing_trust_ukprn).to eql 10059062
      end

      it "the trust must exist" do
        mock_academies_api_trust_not_found(ukprn: 12345678)

        updated_params = {outgoing_trust_ukprn: "12345678"}

        expect(subject.update(updated_params)).to be false
        expect(project.outgoing_trust_ukprn).to eql 10059062
      end

      it "cannot be the same as the incoming trust UKPRN" do
        updated_params = {outgoing_trust_ukprn: "12345678", incoming_trust_ukprn: "12345678"}

        expect(subject.update(updated_params)).to be false
        expect(project.outgoing_trust_ukprn).to eql 10059062
      end
    end

    describe "the incoming trust UKPRN" do
      it "can be changed" do
        updated_params = {incoming_trust_ukprn: "12345678"}

        subject.update(updated_params)

        expect(project.incoming_trust_ukprn).to eql 12345678
      end

      it "cannot be invalid" do
        updated_params = {incoming_trust_ukprn: "2461810"}

        expect(subject.update(updated_params)).to be false
        expect(project.incoming_trust_ukprn).to eql 10059151
      end

      it "the trust must exist" do
        mock_academies_api_trust_not_found(ukprn: 12345678)

        updated_params = {incoming_trust_ukprn: "12345678"}

        expect(subject.update(updated_params)).to be false
        expect(project.incoming_trust_ukprn).to eql 10059151
      end

      it "cannot be the same as the incoming trust UKPRN" do
        updated_params = {outgoing_trust_ukprn: "12345678", incoming_trust_ukprn: "12345678"}

        expect(subject.update(updated_params)).to be false
        expect(project.incoming_trust_ukprn).to eql 10059151
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

    describe "Outgoing trust SharePoint link" do
      it "can be changed" do
        updated_params = {outgoing_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/outing-trust-folder-updated-link"}

        subject.update(updated_params)

        expect(project.outgoing_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/outing-trust-folder-updated-link")
      end

      it "cannot be invalid" do
        updated_params = {outgoing_trust_sharepoint_link: "https://some-other-domain.com/outgoing-trust-folder-updated-link"}

        expect(subject.update(updated_params)).to be false
        expect(project.outgoing_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/outgoing-trust-folder")
      end

      it "cannot be empty" do
        updated_params = {outgoing_trust_sharepoint_link: ""}

        expect(subject.update(updated_params)).to be false
        expect(project.outgoing_trust_sharepoint_link).to eql("https://educationgovuk-my.sharepoint.com/outgoing-trust-folder")
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

    describe "due to an inadequate Ofsted rating" do
      it "can be changed" do
        updated_params = {inadequate_ofsted: "true"}

        subject.update(updated_params)

        expect(project.tasks_data.inadequate_ofsted).to be true

        updated_params = {inadequate_ofsted: "false"}

        subject.update(updated_params)

        expect(project.tasks_data.inadequate_ofsted).to be false
      end
    end

    describe "due to financial, safeguarding or governance issues" do
      it "can be changed" do
        updated_params = {financial_safeguarding_governance_issues: "true"}

        subject.update(updated_params)

        expect(project.tasks_data.financial_safeguarding_governance_issues).to be true

        updated_params = {financial_safeguarding_governance_issues: "false"}

        subject.update(updated_params)

        expect(project.tasks_data.financial_safeguarding_governance_issues).to be false
      end
    end

    describe "outgoing trust close once this transfer is completed" do
      it "can be changed" do
        updated_params = {outgoing_trust_to_close: "true"}

        subject.update(updated_params)

        expect(project.tasks_data.outgoing_trust_to_close).to be true

        updated_params = {outgoing_trust_to_close: "false"}

        subject.update(updated_params)

        expect(project.tasks_data.outgoing_trust_to_close).to be false
      end
    end

    describe "hand over to RCS team" do
      it "does not unassign the project's assigned user" do
        updated_params = {assigned_to_regional_caseworker_team: "true"}

        subject.update(updated_params)

        expect(project.reload.assigned_to).to eq(user)
      end

      describe "sending 'new project to assign' email" do
        context "when assigned to RCS team but NOT assigned to a caseworker" do
          before do
            allow(project).to receive(:assigned_to).and_return(nil)
          end

          it "emails the RCS team leaders" do
            team_leader = create(:user, :team_leader)

            updated_params = {assigned_to_regional_caseworker_team: "true", handover_note_body: "Some notes"}

            subject.update(updated_params)

            expect(ActionMailer::MailDeliveryJob)
              .to(have_been_enqueued.on_queue("default")
                                    .with("TeamLeaderMailer", "new_conversion_project_created", "deliver_now", args: [team_leader, project]))
          end
        end
      end

      context "when assigned to RCS and already assigned to a caseworker" do
        before do
          allow(project).to receive(:assigned_to).and_return(build(:user))
        end

        it "does not send the 'new project to assign email'" do
          team_leader = create(:user, :team_leader)

          updated_params = {assigned_to_regional_caseworker_team: "true", handover_note_body: "Some notes"}

          subject.update(updated_params)

          expect(ActionMailer::MailDeliveryJob)
            .not_to(have_been_enqueued.on_queue("default")
                                  .with("TeamLeaderMailer", "new_conversion_project_created", "deliver_now", args: [team_leader, project]))
        end
      end
    end
  end
end
