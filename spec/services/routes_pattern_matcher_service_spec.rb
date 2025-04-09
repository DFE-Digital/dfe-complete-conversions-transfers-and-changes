require "rails_helper"

RSpec.describe RoutesPatternMatcherService do
  describe "#call" do
    let(:patterns) { double("patterns") }
    let(:route_match) { instance_double(RouteMatch) }
    let(:application_route_1) { double(:application_route_1) }
    let(:application_route_2) { double(:application_route_2) }

    before do
      allow(application_route_1).to receive_message_chain("path.spec.to_s") { "projects/conversions" }
      allow(application_route_2).to receive_message_chain("path.spec.to_s") { "projects/transfers" }

      allow(RouteMatch).to receive(:new).and_return(route_match)

      allow(Rails.application.routes).to receive(:routes).and_return(
        [
          application_route_1,
          application_route_2
        ]
      )
    end

    subject { described_class.new(patterns: patterns) }

    it "creates RouteMatch entities, one per application route" do
      subject.call

      expect(RouteMatch).to have_received(:new).with(
        route: "projects/conversions",
        matching_patterns: patterns
      )

      expect(RouteMatch).to have_received(:new).with(
        route: "projects/transfers",
        matching_patterns: patterns
      )
    end

    it "returns a list of RouteMatch entities, one for each of the applications's routes" do
      expect(subject.call).to eq([route_match, route_match])
    end
  end
end
