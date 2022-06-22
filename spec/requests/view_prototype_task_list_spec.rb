require "rails_helper"

RSpec.describe "View prototypical task list" do
  before do
    allow(Flow).to receive(:load_flow).and_return(
      {
        title: "Flow title",
        description: "Flow description",
        sections: [
          {
            title: "Section one",
            tasks: [{title: "Task one"}, {title: "Task two"}]
          },
          {title: "Section two", tasks: [{title: "Task three"}]}
        ]
      }
    )
  end

  context "when a user visits the prototypical task list" do
    it "displays the flow's title" do
      get tasks_path
      expect(response.body).to include("Prototypical task list: Flow title")
    end

    it "displays the flow description" do
      get tasks_path
      expect(response.body).to include("Flow description")
    end

    it "displays sections" do
      get tasks_path
      expect(response.body).to include("Section one")
      expect(response.body).to include("Section two")
    end

    it "displays tasks" do
      get tasks_path
      expect(response.body).to include("Task one")
      expect(response.body).to include("Task two")
      expect(response.body).to include("Task three")
    end
  end
end
