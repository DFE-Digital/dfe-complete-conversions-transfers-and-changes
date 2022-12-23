require "rails_helper"

RSpec.describe TaskList::Section do
  describe "#locales_path" do
    it "returns the locales path based on the task list class path" do
      task_list = Conversion::Voluntary::TaskList.new
      section = described_class
        .new(identifier: :identifier, tasks: [], locales_path: task_list.locales_path)

      expect(section.locales_path).to eq "conversion.voluntary.task_list.identifier"
    end
  end
end
