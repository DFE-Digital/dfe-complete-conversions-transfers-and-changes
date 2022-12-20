require "rails_helper"

RSpec.describe Conversion::Voluntary::TaskList do
  let(:task_class) { Conversion::Voluntary::Tasks::Handover }
  let(:task_list) {
    Conversion::Voluntary::TaskList.create!(
      handover_review: true
    )
  }

  it_behaves_like "a task list"

  describe "#locales_path" do
    it "returns the appropriate locales path based on the class path" do
      expect(task_list.locales_path).to eq "conversion.voluntary.task_list"
    end
  end
end
