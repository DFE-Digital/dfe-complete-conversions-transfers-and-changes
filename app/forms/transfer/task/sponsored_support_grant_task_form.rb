class Transfer::Task::SponsoredSupportGrantTaskForm < BaseOptionalTaskForm
  attribute :type, :string

  def type_options
    Transfer::TasksData.sponsored_support_grant_types.values
  end
end
