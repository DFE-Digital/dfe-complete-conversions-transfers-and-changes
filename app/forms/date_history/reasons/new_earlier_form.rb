class DateHistory::Reasons::NewEarlierForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  REASONS_LIST = %i[
    progressing_faster_than_expected
    correcting_an_error
  ]

  attribute :project
  attribute :user
  attribute :revised_date, :date
  attribute :progressing_faster_than_expected, :boolean
  attribute :progressing_faster_than_expected_note, :string
  attribute :correcting_an_error, :boolean
  attribute :correcting_an_error_note, :string

  validates :progressing_faster_than_expected_note, presence: true, if: -> { progressing_faster_than_expected.present? }
  validates :correcting_an_error_note, presence: true, if: -> { correcting_an_error.present? }

  validate :at_least_one_reason

  def save
    if valid?
      ::SignificantDateCreatorService.new(
        project: project,
        revised_date: revised_date,
        user: user,
        reasons: collected_reasons
      ).update!
    else
      return false
    end
  end

  def reasons_list
    REASONS_LIST
  end

  private def collected_reasons
    reasons_list.filter_map do |reason|
      {type: reason, note_text: note_for_reason(reason)} if public_send(reason).present?
    end
  end

  private def note_for_reason(reason)
    public_send("#{reason}_note".to_sym)
  end

  private def reason_selected?(reason)
    public_send(reason).present?
  end

  private def at_least_one_reason
    if progressing_faster_than_expected.blank? && correcting_an_error.blank?
      errors.add(:base, :at_least_one_reason)
    end
  end
end
