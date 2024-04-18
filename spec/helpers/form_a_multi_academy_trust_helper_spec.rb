require "rails_helper"

RSpec.describe FormAMultiAcademyTrustHelper, type: :helper do
  describe "#projects_establishment_name_list" do
    it "returns all the project establishment names separated by a semi colon" do
      first_fake_project = double(Project, establishment: double(name: "Fake establishment one"))
      last_fake_project = double(Project, establishment: double(name: "Fake establishment two"))
      fake_project_group = double(FormAMultiAcademyTrust::ProjectGroup, projects: [first_fake_project, last_fake_project])

      expect(projects_establishment_name_list(fake_project_group)).to eql "Fake establishment one; Fake establishment two"
    end

    it "returns an empty string when there are no projects" do
      fake_project_group = double(FormAMultiAcademyTrust::ProjectGroup, projects: [])

      expect(projects_establishment_name_list(fake_project_group)).to eql ""
    end
  end
end
