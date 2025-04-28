class DotnetReroutingRulesService
  def fetch
    rules = Api::Azure::DotnetReroutingRulesClient.new.get_rules
    rules
      .fetch("properties")
      .fetch("conditions").first
      .fetch("parameters")
      .fetch("matchValues")
  end
end
