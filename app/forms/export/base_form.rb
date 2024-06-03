class Export::BaseForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :from_date, :date
  attribute :to_date, :date

  validates :from_date, presence: true
  validates :to_date, presence: true
  validate :from_date_before_to_date

  private def from_date_before_to_date
    return unless from_date.present? && to_date.present?

    errors.add(:from_date, :order) if from_date > to_date
    errors.add(:to_date, :order) if to_date < from_date
  end
end
