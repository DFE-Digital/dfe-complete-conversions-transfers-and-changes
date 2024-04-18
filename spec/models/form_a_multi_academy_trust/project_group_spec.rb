require "rails_helper"

RSpec.describe FormAMultiAcademyTrust::ProjectGroup do
  before do
    mock_all_academies_api_responses
  end

  it "raises an error when no projects with the trust reference number can be found" do
    expect { described_class.new(trn: "TR00000") }.to raise_error FormAMultiAcademyTrust::ProjectGroup::NoProjectsFoundError
  end

  describe "#name" do
    it "returns the first new trust name from the projects" do
      project = create(:conversion_project, :form_a_mat)

      subject = described_class.new(trn: project.new_trust_reference_number)

      expect(subject.name).to eql project.new_trust_name
    end
  end

  describe "#trn" do
    it "returns the trn that the instance was initialized with" do
      project = create(:conversion_project, :form_a_mat)

      subject = described_class.new(trn: project.new_trust_reference_number)

      expect(subject.trn).to eql project.new_trust_reference_number
    end
  end

  describe "#projects" do
    it "returns the projects that make the TRN" do
      conversion_project = create(:conversion_project, :form_a_mat, new_trust_reference_number: "TR12345")
      transfer_project = create(:transfer_project, :form_a_mat, new_trust_reference_number: "TR12345")
      other_project = create(:conversion_project, :form_a_mat, new_trust_reference_number: "TR55555")

      subject = described_class.new(trn: "TR12345")

      expect(subject.projects).to include conversion_project
      expect(subject.projects).to include transfer_project
      expect(subject.projects).not_to include other_project
    end
  end

  describe "#deleted?" do
    it "returns false as project groups don't exist to be deleted" do
      project = create(:conversion_project, :form_a_mat)

      subject = described_class.new(trn: project.new_trust_reference_number)

      expect(subject.deleted?).to be false
    end
  end

  describe ".policy_class" do
    it "returns ProjectPolicy so authorisation is the same as a project" do
      expect(described_class.policy_class).to eql ProjectPolicy
    end
  end
end
