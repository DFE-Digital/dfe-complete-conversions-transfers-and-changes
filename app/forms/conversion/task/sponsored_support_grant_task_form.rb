class Conversion::Task::SponsoredSupportGrantTaskForm < BaseOptionalTaskForm
  attribute :payment_amount, :boolean
  attribute :payment_form, :boolean
  attribute :send_information, :boolean
  attribute :inform_trust, :boolean
  attribute :type, :string

  def type_options
    Conversion::TasksData.sponsored_support_grant_types.values
  end
end
