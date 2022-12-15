require "rails_helper"

RSpec.describe TaskList::Section do
  describe "#title" do
    let(:section) { described_class.new(identifier:, tasks: []) }
    let(:identifier) { :project_kick_off }
    let(:title) { "Project kick-off" }

    before { allow(I18n).to receive(:t).with("task_list.sections.#{identifier}.title").and_return(title) }

    subject { section.title }

    it "returns the section title from the translation file" do
      expect(subject).to eq title
    end
  end
end
