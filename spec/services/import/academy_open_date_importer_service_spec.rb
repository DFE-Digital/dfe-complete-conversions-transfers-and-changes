require "rails_helper"

RSpec.describe Import::AcademyOpenDateImporterService do
  let(:good_csv) do
    <<~CSV
      previous_urn,academy_urn,date
      122957,138205,01/01/2024
    CSV
  end

  before do
    allow(File).to receive(:open).and_return(good_csv)

    mock_all_academies_api_responses
  end

  subject { described_class.new("/path/to/fake.csv").import! }

  context "when a project with the two urns exists" do
    it "updates the date and returns a result with success set to true" do
      tasks_data = create(:conversion_tasks_data, confirm_date_academy_opened_date_opened: nil)
      project = create(:conversion_project, tasks_data: tasks_data, urn: 122957, academy_urn: 138205)

      expect(subject.first[:success]).to be true
      expect(project.reload.tasks_data.confirm_date_academy_opened_date_opened).to eql Date.new(2024, 1, 1)
    end
  end

  context "when a project with the two urns does not exist" do
    it "returns a result with success set to false" do
      tasks_data = create(:conversion_tasks_data, confirm_date_academy_opened_date_opened: nil)
      project = create(:conversion_project, tasks_data: tasks_data, urn: 120685, academy_urn: 120684)

      expect(subject.first[:success]).to be false
      expect(project.reload.tasks_data.confirm_date_academy_opened_date_opened).to be_nil
    end
  end
end
