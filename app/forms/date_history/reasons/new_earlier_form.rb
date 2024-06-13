class DateHistory::Reasons::NewEarlierForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :project
  attribute :user
  attribute :reasons
  attribute :revised_date, :date
  attribute :correcting_an_error, :boolean
  attribute :correcting_an_error_note, :string
end
