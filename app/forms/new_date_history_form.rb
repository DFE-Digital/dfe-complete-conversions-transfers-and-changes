class NewDateHistoryForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :project
  attribute :user
  attribute :note_body
  attribute :revised_date, :date

  validates :project, :user, :revised_date, :note_body, presence: true

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:revised_date, attributes, without_day: true).invalid?
      attributes.delete("revised_date(3i)")
      attributes.delete("revised_date(2i)")
      attributes.delete("revised_date(1i)")
    end

    super
  end

  def save
    return false unless valid?

    if SignificantDateCreatorService.new(project: project, revised_date: revised_date, note_body: note_body, user: user).update!
      true
    else
      errors.add(:revised_date, :transaction)
      false
    end
  end
end
