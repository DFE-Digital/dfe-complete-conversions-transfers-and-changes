class DateHistory::Reasons::BaseForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :project
  attribute :user
  attribute :revised_date, :date

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
      false
    end
  end

  def reasons_list
    raise StandardError.new("You must implement reason_list")
  end

  private def collected_reasons
    reasons_list.filter_map do |reason|
      {type: reason, note_text: note_for_reason(reason)} if public_send(reason).present?
    end
  end

  private def note_for_reason(reason)
    public_send(:"#{reason}_note")
  end

  private def reason_selected?(reason)
    public_send(reason).present?
  end

  private def at_least_one_reason
    selected_reasons = reasons_list.filter_map do |reason|
      reason_selected?(reason)
    end

    errors.add(:base, :at_least_one_reason) if selected_reasons.empty?
  end
end
