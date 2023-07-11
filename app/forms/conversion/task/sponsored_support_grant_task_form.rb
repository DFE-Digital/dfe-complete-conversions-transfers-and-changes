class Conversion::Task::SponsoredSupportGrantTaskForm < BaseOptionalTaskForm
  attribute :eligibility, :boolean
  attribute :payment_amount, :boolean
  attribute :payment_form, :boolean
  attribute :send_information, :boolean
  attribute :inform_trust, :boolean
  attribute :type, :string
end
