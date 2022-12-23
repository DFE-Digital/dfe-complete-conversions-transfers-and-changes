require "rails_helper"

RSpec.describe TaskList::TaskHeaderComponent, type: :component do
  let(:project) { create(:conversion_project) }
  let(:task) { double(status: :not_started, locales_path: "conversion.voluntary.tasks.handover") }

  before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

  it "renders the title component" do
    render_inline(TaskList::TaskHeaderComponent.new(project: project, task: task))

    expect(page).to have_text(project.establishment.name)
    expect(page).to have_text("Handover with regional delivery officer")
  end
end
