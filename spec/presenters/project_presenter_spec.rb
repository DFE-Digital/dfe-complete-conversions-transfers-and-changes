require "rails_helper"

RSpec.describe ProjectPresenter do
  describe "#advisory_board_date" do
    it "returns the formatted date" do
      project = build(:conversion_project)
      expect(described_class.new(project).advisory_board_date)
        .to eq(project.advisory_board_date.to_formatted_s(:govuk))
    end

    it "can be empty when there is no advisory board date" do
      project = build(:conversion_project, advisory_board_date: nil)
      expect(described_class.new(project).advisory_board_date)
        .to be_nil
    end
  end
end
