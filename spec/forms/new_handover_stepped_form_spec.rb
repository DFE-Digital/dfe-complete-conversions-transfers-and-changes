require "rails_helper"

RSpec.describe NewHandoverSteppedForm, type: :model do
  before do
    mock_successful_api_response_to_create_any_project
  end

  describe "validations" do
    context "in the default validation context" do
      context "for a conversion project" do
        let(:regional_delivery_officer) { create(:regional_delivery_officer_user) }
        let(:project) { create(:conversion_project) }
        let(:params) { valid_conversion_attributes }
        subject { described_class.new(project, regional_delivery_officer, params) }

        describe "with all valid attributes" do
          it "is valid" do
            params[:team] = nil
            params[:email] = nil

            expect(subject).to be_valid
          end
        end

        describe "assigned to regional casework team" do
          it "is required" do
            params[:assigned_to_regional_caseworker_team] = nil

            expect(subject).to be_invalid
          end
        end

        describe "handover note" do
          it "is required" do
            params[:handover_note_body] = nil

            expect(subject).to be_invalid
          end
        end

        describe "sharepoint links" do
          it "establishment is required" do
            params[:establishment_sharepoint_link] = nil

            expect(subject).to be_invalid
          end

          it "incoming trust is required" do
            params[:incoming_trust_sharepoint_link] = nil

            expect(subject).to be_invalid
          end

          it "must be a valid sharepoint link" do
            params[:establishment_sharepoint_link] = "http://not.sharepoint.com"

            expect(subject).to be_invalid
          end
        end

        describe "requires two requires improvement" do
          it "is required" do
            params[:two_requires_improvement] = nil

            expect(subject).to be_invalid
          end
        end
      end

      context "for a transfer project" do
        let(:regional_delivery_officer) { create(:regional_delivery_officer_user) }
        let(:project) { create(:transfer_project) }
        let(:params) { valid_transfer_attributes }
        subject { described_class.new(project, regional_delivery_officer, params) }

        describe "with all valid attributes" do
          it "is valid" do
            params[:team] = nil
            params[:email] = nil

            expect(subject).to be_valid
          end
        end

        describe "assigned to regional casework team" do
          it "is required" do
            params[:assigned_to_regional_caseworker_team] = nil

            expect(subject).to be_invalid
          end
        end

        describe "handover note" do
          it "is required" do
            params[:handover_note_body] = nil

            expect(subject).to be_invalid
          end
        end

        describe "sharepoint links" do
          it "establishment is required" do
            params[:establishment_sharepoint_link] = nil

            expect(subject).to be_invalid
          end

          it "incoming trust is required" do
            params[:incoming_trust_sharepoint_link] = nil

            expect(subject).to be_invalid
          end

          it "outgoing trust is required" do
            params[:outgoing_trust_sharepoint_link] = nil

            expect(subject).to be_invalid
          end

          it "must be a valid sharepoint link" do
            params[:establishment_sharepoint_link] = "http://not.sharepoint.com"

            expect(subject).to be_invalid
          end
        end
      end
    end

    context "in the assign validation context" do
      context "for a conversion project" do
        let(:regional_delivery_officer) { create(:regional_delivery_officer_user) }
        let(:project) { create(:conversion_project) }
        let(:params) { valid_conversion_attributes }
        subject { described_class.new(project, regional_delivery_officer, params) }

        describe "with all valid attributes" do
          it "is valid" do
            expect(subject).to be_valid(:assign)
          end
        end

        it "requires the default attributes" do
          params[:assigned_to_regional_caseworker_team] = nil
          params[:handover_note_body] = nil
          params[:establishment_sharepoint_link] = nil
          params[:incoming_trust_sharepoint_link] = nil
          params[:two_requires_improvement] = nil

          expect(subject).to be_invalid(:assign)
        end

        describe "team" do
          it "is required" do
            params[:team] = nil

            expect(subject).to be_invalid(:assign)
          end

          it "must be a valid team" do
            params[:team] = "not_a_team"

            expect(subject).to be_invalid(:assign)
          end
        end

        describe "email" do
          it "is required" do
            params[:email] = nil

            expect(subject).to be_invalid(:assign)
          end

          it "must be an @education.gov.uk address" do
            params[:email] = "test.user@another.com"

            expect(subject).to be_invalid(:assign)
          end

          it "must be a valid email address" do
            params[:email] = "test.user.another.com"

            expect(subject).to be_invalid(:assign)
          end
        end
      end

      context "for a transfer project" do
        let(:regional_delivery_officer) { create(:regional_delivery_officer_user) }
        let(:project) { create(:transfer_project) }
        let(:params) { valid_transfer_attributes }
        subject { described_class.new(project, regional_delivery_officer, params) }

        describe "with all valid attributes" do
          it "is valid" do
            expect(subject).to be_valid(:assign)
          end
        end

        it "requires the default attributes" do
          params[:assigned_to_regional_caseworker_team] = nil
          params[:handover_note_body] = nil
          params[:establishment_sharepoint_link] = nil
          params[:incoming_trust_sharepoint_link] = nil
          params[:outgoing_trust_sharepoint_link] = nil

          expect(subject).to be_invalid(:assign)
        end

        describe "team" do
          it "is required" do
            params[:team] = nil

            expect(subject).to be_invalid(:assign)
          end

          it "must be a valid team" do
            params[:team] = "not_a_team"

            expect(subject).to be_invalid(:assign)
          end
        end

        describe "email" do
          it "is required" do
            params[:email] = nil

            expect(subject).to be_invalid(:assign)
          end

          it "must be an @education.gov.uk address" do
            params[:email] = "test.user@another.com"

            expect(subject).to be_invalid(:assign)
          end

          it "must be a valid email address" do
            params[:email] = "test.user.another.com"

            expect(subject).to be_invalid(:assign)
          end
        end
      end
    end
  end

  describe ".list_of_teams" do
    it "returns an ordered  list of teams with id and name" do
      team_list = described_class.list_of_teams

      expect(team_list.first.id).to eql("east_midlands")
      expect(team_list.first.name).to eql("East Midlands")

      expect(team_list.last.id).to eql("yorkshire_and_the_humber")
      expect(team_list.last.name).to eql("Yorkshire and the Humber")
    end
  end

  describe "#save" do
    it "updates the project, making it valid and sets the state to active" do
      user = create(:regional_delivery_officer_user, email: "test.user@education.gov.uk")
      project = build(
        :conversion_project,
        :inactive,
        establishment_sharepoint_link: nil,
        incoming_trust_sharepoint_link: nil,
        two_requires_improvement: nil
      )

      expect(project).to be_invalid

      subject = described_class.new(project, user, valid_conversion_attributes).save

      expect(subject).to be_valid
      expect(project.establishment_sharepoint_link).to eql "https://educationgovuk-my.sharepoint.com/establishment"
      expect(project.incoming_trust_sharepoint_link).to eql "https://educationgovuk-my.sharepoint.com/incoming_trust"
      expect(project.two_requires_improvement).to be true
      expect(project).to be_active
    end

    it "creates the handover note" do
      user = create(:regional_delivery_officer_user, email: "test.user@education.gov.uk")
      project = build(
        :conversion_project,
        :inactive
      )

      expect(project.notes.count).to be_zero

      described_class.new(project, user, valid_conversion_attributes).save
      subject = project.handover_note

      expect(subject.body).to eql "This is a test note.\n\nUsed in tests."
      expect(subject.user).to eql user
    end

    context "when assigned to regional casework services team" do
      it "assigns correctly" do
        user = create(:regional_delivery_officer_user, email: "test.user@education.gov.uk")
        project = build(
          :conversion_project,
          :inactive,
          team: nil,
          assigned_to: nil
        )
        params = valid_conversion_attributes
        params[:assigned_to_regional_caseworker_team] = true
        params[:team] = nil
        params[:email] = nil

        described_class.new(project, user, params).save

        expect(project.team).to eql "regional_casework_services"
        expect(project.assigned_to).to be_nil
      end
    end

    context "when assigned to a regional team" do
      it "assigns correctly" do
        assigned_user = create(:regional_delivery_officer_user, email: "east.midlands@education.gov.uk")
        user = create(:regional_delivery_officer_user, email: "test.user@education.gov.uk")
        project = build(
          :conversion_project,
          :inactive,
          team: nil,
          assigned_to: nil
        )
        params = valid_conversion_attributes
        params[:assigned_to_regional_caseworker_team] = false
        params[:team] = "east_midlands"
        params[:email] = "east.midlands@education.gov.uk"

        described_class.new(project, user, params).save

        expect(project.team).to eql "east_midlands"
        expect(project.assigned_to).to eql assigned_user
      end
    end
  end

  def valid_conversion_attributes
    {
      assigned_to_regional_caseworker_team: true,
      handover_note_body: "This is a test note.\n\nUsed in tests.",
      establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment",
      incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust",
      two_requires_improvement: true,
      team: "east_midlands",
      email: "test.user@education.gov.uk"
    }
  end

  def valid_transfer_attributes
    {
      assigned_to_regional_caseworker_team: true,
      handover_note_body: "This is a test note.\n\nUsed in tests.",
      establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment",
      incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust",
      outgoing_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust",
      team: "east_midlands",
      email: "test.user@education.gov.uk"
    }
  end
end
