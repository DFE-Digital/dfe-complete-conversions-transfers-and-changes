require "rails_helper"

RSpec.describe ServiceSupport::DotnetReroutingRulesController do
  let(:user) { create(:user, :service_support) }

  before { sign_in_with(user) }

  describe "GET :show" do
    let(:patterns) { ["projects/conversions", "dist"] }
    let(:routes_with_matches) { double("routes with matches") }

    let(:service) { instance_double(DotnetReroutingRulesService, fetch: patterns) }
    let(:pattern_matcher) { instance_double(RoutesPatternMatcherService, call: routes_with_matches) }

    before do
      allow(DotnetReroutingRulesService).to receive(:new).and_return(service)
      allow(RoutesPatternMatcherService).to receive(:new).and_return(pattern_matcher)
    end

    it "ask RoutesPatternMatcher for a list of routes showing matches against given patterns" do
      get :show

      expect(RoutesPatternMatcherService).to have_received(:new).with(patterns: patterns)
      expect(pattern_matcher).to have_received(:call)
    end
  end
end
