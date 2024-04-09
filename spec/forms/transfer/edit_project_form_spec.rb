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

  subject { Transfer::EditProjectForm.new_from_project(project) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
  end

  describe "#update" do
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
        mock_trust_not_found(ukprn: 12345678)

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
        mock_trust_not_found(ukprn: 12345678)

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
  end
end
