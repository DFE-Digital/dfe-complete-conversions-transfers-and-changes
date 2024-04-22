require "rails_helper"

RSpec.describe FormAMultiAcademyTrust::ProjectGroupFetcherService do
  describe "#call" do
    context "when there are projects to group" do
      it "returns an array of ProjectGroup" do
        mock_all_academies_api_responses
        conversion_project = create(:conversion_project, :form_a_mat, new_trust_reference_number: "TR12345", new_trust_name: "The big trust")
        transfer_project = create(:transfer_project, :form_a_mat, new_trust_reference_number: "TR12345", new_trust_name: "The big trust")
        other_project = create(:conversion_project, :form_a_mat, new_trust_reference_number: "TR10000", new_trust_name: "Another trust")

        result = described_class.new.call

        expect(result.count).to be 2

        first_group = result.first

        expect(first_group.name).to eql "Another trust"
        expect(first_group.projects).to include other_project
        expect(first_group.projects).not_to include conversion_project
        expect(first_group.projects).not_to include transfer_project

        last_group = result.last

        expect(last_group.name).to eql "The big trust"
        expect(last_group.projects).to include conversion_project
        expect(last_group.projects).to include transfer_project
        expect(last_group.projects).not_to include other_project
      end
    end

    context "when there are only completed projects to group" do
      it "returns empty" do
        mock_all_academies_api_responses
        create(:conversion_project, :form_a_mat, state: :completed)
        create(:transfer_project, :form_a_mat, state: :completed)

        result = described_class.new.call

        expect(result).to be_empty
      end
    end

    context "when there are no projects to group" do
      it "returns empty" do
        result = described_class.new.call

        expect(result).to be_empty
      end
    end
  end
end
