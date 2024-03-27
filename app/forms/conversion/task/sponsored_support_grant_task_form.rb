class Conversion::Task::SponsoredSupportGrantTaskForm < BaseOptionalTaskForm
  attribute :payment_amount, :boolean
  attribute :payment_form, :boolean
  attribute :send_information, :boolean
  attribute :inform_trust, :boolean
  attribute :type, :string

  def type_options
    Conversion::TasksData.sponsored_support_grant_types.values
  end

  def save
    if not_applicable
      @tasks_data.sponsored_support_grant_type = nil
      @tasks_data.assign_attributes prefixed_attributes.except("sponsored_support_grant_type")
    else
      @tasks_data.assign_attributes prefixed_attributes
    end
    @tasks_data.save!
  end
end
