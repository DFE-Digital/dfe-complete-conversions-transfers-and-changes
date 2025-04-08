class ServiceSupport::DotnetReroutingRulesController < ApplicationController
  def show
    @patterns = DotnetReroutingRulesService.new.fetch
  end
end
