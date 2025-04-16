require "rails_helper"

RSpec.describe RouteMatch do
  let(:patterns) do
    [
      "project/conversions",
      "dist"
    ]
  end

  describe "#route" do
    let(:route_match) do
      RouteMatch.new(route: "project/123", matching_patterns: patterns)
    end

    it "returns the _route_ used in initalisation" do
      expect(route_match.route).to eq("project/123")
    end
  end

  describe "#match?" do
    context "when the given route matches one of the given patterns" do
      let(:route_match) do
        RouteMatch.new(route: "project/conversions", matching_patterns: patterns)
      end

      it "returns true" do
        expect(route_match.match?).to be true
      end
    end

    context "when the given route does NOT match one of the given patterns" do
      let(:route_match) do
        RouteMatch.new(route: "project/transfers", matching_patterns: patterns)
      end

      it "returns false" do
        expect(route_match.match?).to be false
      end
    end
  end
end
