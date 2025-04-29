class ServiceSupport::DotnetReroutingRulesController < ApplicationController
  after_action :verify_authorized

  def show
    authorize(:rerouting, :show?, policy_class: ReroutingPolicy)

    @patterns = DotnetReroutingRulesService.new.fetch
    @routes = RoutesPatternMatcherService.new(patterns: @patterns).call
  end
end
