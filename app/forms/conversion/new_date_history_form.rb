class Conversion::NewDateHistoryForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  CONVERSION_DATE_DAY = 1

  attribute :project
  attribute :user
  attribute :note_body
  attribute :revised_date
  attribute "revised_date(3i)"
  attribute "revised_date(2i)"
  attribute "revised_date(1i)"

  validates :project, :user, :note_body, presence: true

  validate :revised_date_format

  def save
    return false unless valid?

    if ConversionDateUpdater.new(project: project, revised_date: date_from_attributes, note_body: note_body, user: user).update!
      true
    else
      errors.add(:revised_date, :transaction)
      false
    end
  end

  private def revised_date_format
    errors.add(:revised_date, :format) if month.blank? || year.blank?
    errors.add(:revised_date, :format) unless (1..12).cover?(month.to_i)
    errors.add(:revised_date, :format) unless (2000..2500).cover?(year.to_i)
  end

  private def day
    CONVERSION_DATE_DAY.to_i
  end

  private def month
    attributes["revised_date(2i)"].to_i
  end

  private def year
    attributes["revised_date(1i)"].to_i
  end

  private def date_from_attributes
    Date.new(year, month, day)
  end
end
