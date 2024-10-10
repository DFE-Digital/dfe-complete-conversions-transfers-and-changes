require "rails_helper"

RSpec.describe NewHandoverForm, type: :model do
  before do
    mock_successful_api_response_to_create_any_project
  end

  describe "validations" do
    context "for a conversion project" do
      let(:regional_delivery_officer) { create(:regional_delivery_officer_user) }
      let(:project) { create(:conversion_project) }
      let(:params) { valid_conversion_attributes }
      subject { described_class.new(project, regional_delivery_officer, params) }

      describe "with all valid attributes" do
        it "is valid" do
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
        it "is required when assiging to regional casework team" do
          params[:assigned_to_regional_caseworker_team] = true
          params[:handover_note_body] = nil

          expect(subject).to be_invalid
        end

        it "is optional when not assiging to regional casework team" do
          params[:assigned_to_regional_caseworker_team] = false
          params[:handover_note_body] = nil

          expect(subject).to be_valid
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
        it "is required when assiging to regional casework team" do
          params[:assigned_to_regional_caseworker_team] = true
          params[:handover_note_body] = nil

          expect(subject).to be_invalid
        end

        it "is optional when not assiging to regional casework team" do
          params[:assigned_to_regional_caseworker_team] = false
          params[:handover_note_body] = nil

          expect(subject).to be_valid
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

        described_class.new(project, user, params).save

        expect(project.team).to eql "regional_casework_services"
        expect(project.assigned_to).to be_nil
      end
    end

    context "when assigned to a regional team" do
      it "assigns correctly" do
        user = create(:regional_delivery_officer_user, email: "test.user@education.gov.uk", team: :east_midlands)
        project = build(
          :conversion_project,
          :inactive,
          team: nil,
          assigned_to: nil
        )
        params = valid_conversion_attributes
        params[:assigned_to_regional_caseworker_team] = false

        described_class.new(project, user, params).save

        expect(project.team).to eql "east_midlands"
        expect(project.assigned_to).to eql user
      end
    end
  end

  def valid_conversion_attributes
    {
      assigned_to_regional_caseworker_team: true,
      handover_note_body: "This is a test note.\n\nUsed in tests.",
      establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment",
      incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust",
      two_requires_improvement: true
    }
  end

  def valid_transfer_attributes
    {
      assigned_to_regional_caseworker_team: true,
      handover_note_body: "This is a test note.\n\nUsed in tests.",
      establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment",
      incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust",
      outgoing_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust"
    }
  end
end
