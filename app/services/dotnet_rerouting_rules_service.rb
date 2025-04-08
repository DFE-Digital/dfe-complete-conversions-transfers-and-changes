class DotnetReroutingRulesService
  def fetch
    rules = Api::Azure::DotnetReroutingRulesClient.new.get
    rules
      .fetch("value").first
      .fetch("properties")
      .fetch("conditions").first
      .fetch("parameters")
      .fetch("matchValues")
  end
end
