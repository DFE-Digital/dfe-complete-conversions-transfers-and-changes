class ServiceSupport::DotnetReroutingRulesController < ApplicationController
  def show
    @patterns = DotnetReroutingRulesService.new.fetch
    @routes = RoutesPatternMatcherService.new(patterns: @patterns).call
  end
end
