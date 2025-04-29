require "rails_helper"

RSpec.describe ServiceSupport::DotnetReroutingRulesController do
  let(:patterns) { ["projects/conversions", "dist"] }
  let(:routes_with_matches) { double("routes with matches") }

  let(:service) { instance_double(DotnetReroutingRulesService, fetch: patterns) }
  let(:pattern_matcher) { instance_double(RoutesPatternMatcherService, call: routes_with_matches) }

  describe "GET :show" do
    let(:user) { create(:user, :service_support) }
    before { sign_in_with(user) }

    before do
      allow(DotnetReroutingRulesService).to receive(:new).and_return(service)
      allow(RoutesPatternMatcherService).to receive(:new).and_return(pattern_matcher)
    end

    it "ask RoutesPatternMatcher for a list of routes showing matches against given patterns" do
      get :show

      expect(RoutesPatternMatcherService).to have_received(:new).with(patterns: patterns)
      expect(pattern_matcher).to have_received(:call)
    end

    context "when I'm a logged in as member of a different team (not service support)" do
      let(:caseworker) { create(:user, :caseworker) }

      before { sign_in_with(caseworker) }

      it "denies access" do
        get :show

        expect(response).to redirect_to(root_path)
      end

      context "when I have the 'devops' user capabability" do
        before { caseworker.capabilities << Capability.devops }

        it "grants access" do
          get :show

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
