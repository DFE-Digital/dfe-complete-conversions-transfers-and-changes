class NewDateHistoryForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :project
  attribute :user
  attribute :revised_date, :date

  validates :project, :user, :revised_date, presence: true
  validate :revised_date_not_previous_date, if: -> { project.present? }

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:revised_date, attributes, without_day: true).invalid?
      attributes.delete("revised_date(3i)")
      attributes.delete("revised_date(2i)")
      attributes.delete("revised_date(1i)")
    end

    super
  end

  private def revised_date_not_previous_date
    errors.add(:revised_date, :same_as_previous_date) if revised_date.eql?(project.significant_date)
  end
end
