class NewDateHistoryForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :project
  attribute :user
  attribute :revised_date, :date

  validates :project, :user, :revised_date, presence: true

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:revised_date, attributes, without_day: true).invalid?
      attributes.delete("revised_date(3i)")
      attributes.delete("revised_date(2i)")
      attributes.delete("revised_date(1i)")
    end

    super
  end
end
