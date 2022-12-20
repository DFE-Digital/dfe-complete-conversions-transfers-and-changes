require "rails_helper"

RSpec.describe Conversion::Involuntary::TaskList do
  let(:task_class) { Conversion::Involuntary::Tasks::Handover }
  let(:task_list) {
    Conversion::Involuntary::TaskList.create!(
      handover_review: true
    )
  }

  it_behaves_like "a task list"

  describe "#locales_path" do
    it "returns the appropriate locales path based on the class path" do
      expect(task_list.locales_path).to eq "conversion.involuntary.task_list"
    end
  end
end
