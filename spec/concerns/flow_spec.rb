require "rails_helper"

RSpec.describe Flow do
  describe "#self.load_flow" do
    it "parses and outputs a file correctly" do
      allow(YAML).to receive(:load_file).with("flows/test_flow.yml").and_return(
        {
          title: "Title", # These keys are intentionally strings not symbols, because that's what load_file returns
          description: "Description",
          sections: %w[section_1 section_2]
        }
      )

      parsed_flow = Flow.load_flow("test_flow")

      expect(parsed_flow).to eq(
        {
          title: "Title",
          description: "<p class=\"govuk-body-m\">Description</p>",
          sections: %w[section_1 section_2]
        }
      )
    end
  end
end
