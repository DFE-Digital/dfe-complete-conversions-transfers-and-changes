class SignificantDateCreatorService
  def initialize(project:, revised_date:, user:, reasons: [])
    @project = project
    @previous_date = @project.significant_date
    @revised_date = revised_date
    @user = user
    @reasons = reasons

    raise ArgumentError.new("Reasons cannot be nil") if @reasons.nil?
    raise ArgumentError.new("You must supply at least one reason.") if @reasons.empty?
  end

  def update!
    ActiveRecord::Base.transaction do
      date_history = SignificantDateHistory.create!(user: @user, project_id: @project.id, previous_date: @previous_date, revised_date: @revised_date)

      reasons = create_reasons_for(date_history)

      @project.update!(significant_date: @revised_date, significant_date_provisional: false)

      raise ActiveRecord::RecordInvalid unless @project.persisted? && date_history.persisted? && reasons.map(&:persisted?)
    rescue ActiveRecord::RecordInvalid
      return false
    end

    true
  end

  private def create_reasons_for(date_history)
    @reasons.map do |reason|
      raise ArgumentError.new("Date history reason is invalid, each reason must be a hash with :type and :note_text keys") unless reason_valid?(reason)

      note = create_note_with(reason[:note_text])

      SignificantDateHistoryReason.create!(
        significant_date_history_id: date_history.id,
        reason_type: reason[:type],
        note: note
      )
    end
  end

  private def create_note_with(body)
    Note.create!(project_id: @project.id, user_id: @user.id, body: body)
  end

  private def reason_valid?(reason)
    reason.has_key?(:type) && reason.has_key?(:note_text)
  end
end
